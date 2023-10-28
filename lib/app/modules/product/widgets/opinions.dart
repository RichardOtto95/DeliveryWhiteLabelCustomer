import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/product/widgets/see_all_button.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../product_store.dart';

class Opinions extends StatelessWidget {
  final ProductStore store = Modular.get();
  final Ads model;

  Opinions({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(context) {
    int _page = 0;
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("ads")
          .doc(model.id)
          .collection("ratings")
          .where("status", isEqualTo: "VISIBLE")
          .orderBy("created_at", descending: true)
          .limit(15)
          .get(),
      builder: (context, snapshotStream) {
        if (snapshotStream.hasError) {
          print(snapshotStream.error);
        }
        if (!snapshotStream.hasData) {
          return Container();
        }
        if (snapshotStream.data!.docs.isEmpty) {
          return Container();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          store.getRatings(_page, snapshotStream.data!.docs);
        });
        // QuerySnapshot ratingsQuery = snapshotStream.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: wXD(23, context), left: wXD(24, context)),
              child: Text(
                'Opiniões sobre o produto',
                style: textFamily(
                  context,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: getColors(context).onBackground,
                ),
              ),
            ),
            Row(
              children: [
                FutureBuilder<Map<String, dynamic>>(
                  future: store.getAverageEvaluation(model.id),
                  builder: (context, snapshotFuture) {
                    num lengthRating = 0;
                    num averageRating = 0;
                    if (snapshotFuture.hasData) {
                      Map<String, dynamic> response = snapshotFuture.data!;
                      lengthRating = response['length-rating'];
                      averageRating = response['average-rating'];
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), left: wXD(23, context)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            averageRating.toDouble().toString(),
                            style: textFamily(
                              context,
                              fontSize: 31,
                              fontWeight: FontWeight.w600,
                              color: getColors(context).primary,
                            ),
                          ),
                          SizedBox(width: wXD(20, context)),
                          Column(
                            children: [
                              RatingBar(
                                initialRating: averageRating.toDouble(),
                                ignoreGestures: true,
                                onRatingUpdate: (value) {},
                                glowColor:
                                    getColors(context).primary.withOpacity(.4),
                                unratedColor:
                                    getColors(context).primary.withOpacity(.4),
                                allowHalfRating: true,
                                itemSize: wXD(20, context),
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star_rounded,
                                      color: getColors(context).primary),
                                  empty: Icon(Icons.star_outline_rounded,
                                      color: getColors(context).primary),
                                  half: Icon(Icons.star_half_rounded,
                                      color: getColors(context).primary),
                                ),
                              ),
                              Text(
                                lengthRating == 1
                                    ? "Média entre 1 opinião"
                                    : "Média entre $lengthRating opiniões",
                                style: textFamily(
                                  context,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                  color: getColors(context).primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: wXD(13, context)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: getColors(context)
                              .onBackground
                              .withOpacity(.2)))),
              width: maxWidth(context),
              child: DefaultTabController(
                length: 3,
                child: TabBar(
                  onTap: (page) {
                    _page = page;
                    store.getRatings(page, snapshotStream.data!.docs);
                  },
                  indicatorColor: getColors(context).primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: getColors(context).primary,
                  labelStyle: textFamily(context, fontWeight: FontWeight.w500),
                  unselectedLabelColor: getColors(context).onBackground,
                  indicatorWeight: 3,
                  tabs: [Text('Todas'), Text('Positivas'), Text('Negativas')],
                ),
              ),
            ),
            Observer(
              builder: (context) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: store.ratings.isEmpty
                        ? [
                            Icon(
                              Icons.star_border_rounded,
                              size: wXD(200, context),
                              color: getColors(context).onBackground,
                            ),
                            Observer(
                              builder: (context) {
                                return Text(
                                    _page == 1
                                        ? "Sem avaliações positivas"
                                        : "Sem avaliações negativas",
                                    style: textFamily(
                                      context,
                                    ));
                              },
                            ),
                          ]
                        : store.ratings
                            .map((e) => Opinion(
                                  productOpnion: e['opnion'],
                                  productAnswer: e['answer'],
                                  rating: e['rating'].toDouble(),
                                ))
                            .toList(),
                  ),
                );
              },
            ),
            SizedBox(height: wXD(18, context)),
            snapshotStream.data!.docs.length < 15
                ? SeeAllButton(
                    title: 'Ver todas as opiniões',
                    onTap: () => Modular.to
                        .pushNamed('/product/ratings', arguments: model.id))
                : Container(),
            SizedBox(height: wXD(24, context)),
          ],
        );
      },
    );
  }
}

class Opinion extends StatelessWidget {
  final double rating;
  final String? productOpnion;
  final String? productAnswer;

  Opinion({
    Key? key,
    required this.rating,
    this.productOpnion,
    this.productAnswer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: wXD(126, context),
      width: maxWidth(context),
      padding: EdgeInsets.fromLTRB(
        wXD(24, context),
        wXD(23, context),
        wXD(22, context),
        wXD(16, context),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onBackground.withOpacity(.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar(
            initialRating: rating,
            ignoreGestures: true,
            onRatingUpdate: (value) {},
            glowColor: getColors(context).primary.withOpacity(.4),
            unratedColor: getColors(context).primary.withOpacity(.4),
            allowHalfRating: true,
            itemSize: wXD(16, context),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star_rounded, color: getColors(context).primary),
              empty: Icon(Icons.star_outline_rounded,
                  color: getColors(context).primary),
              half: Icon(Icons.star_half_rounded,
                  color: getColors(context).primary),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: wXD(21, context), bottom: wXD(6, context)),
            child: Text(
              getRatingString(),
              style: textFamily(
                context,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          if (productOpnion != null)
            Text(
              productOpnion!,
              style: textFamily(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: getColors(context).onBackground.withOpacity(.8),
              ),
            ),
          if (productAnswer != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: wXD(14, context),
                  width: wXD(14, context),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: getColors(context).onSurface.withOpacity(.4)),
                      left: BorderSide(
                          color: getColors(context).onSurface.withOpacity(.4)),
                    ),
                  ),
                  margin: EdgeInsets.fromLTRB(
                    wXD(3, context),
                    wXD(3, context),
                    wXD(3, context),
                    wXD(8, context),
                  ),
                ),
                Text(
                  productAnswer!,
                  style: textFamily(
                    context,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: getColors(context).onBackground.withOpacity(.6),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String getRatingString() {
    if (rating == 5) {
      return "Ótimo";
    } else if (rating >= 4) {
      return "Bom";
    } else if (rating >= 3) {
      return "Regular";
    } else if (rating >= 2) {
      return "Ruim";
    } else if (rating >= 1) {
      return "Péssimo";
    }
    return "Erro";
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_customer/app/core/models/ads_model.dart';
import 'package:delivery_customer/app/modules/product/product_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/floating_circle_button.dart';
import 'package:delivery_customer/app/shared/widgets/stars_load_circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../shared/color_theme.dart';

// ignore: must_be_immutable
class ItemData extends StatefulWidget {
  final Ads model;
  ItemData({Key? key, required this.model}) : super(key: key);

  @override
  State<ItemData> createState() => _ItemDataState();
}

class _ItemDataState extends State<ItemData> {
  final ProductStore store = Modular.get();
  bool? liked;
  num? likeCount;

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      store.setImageIndex(
          (wXD(scrollController.offset, context) ~/ wXD(130.56, context))
                  .toInt() +
              1);
    });
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: wXD(60, context)),
          // height: maxWidth(context),
          width: maxWidth(context),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            // padding: EdgeInsets.only(right: wXD(10, context)),
            physics: const PageScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: maxWidth(context),
                  width: maxWidth(context),
                  child: PageView(
                    children: List.generate(
                      widget.model.images.length,
                      (index) => CachedNetworkImage(
                        imageUrl: widget.model.images[index],
                        height: maxWidth(context),
                        width: maxWidth(context),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, str, value) {
                          // print(value.progress);
                          return Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: value.progress,
                            ),
                          );
                        },
                      ),
                    ),
                    onPageChanged: (page) => store.imageIndex = page + 1,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: wXD(18, context), top: wXD(15, context)),
                  width: wXD(317, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'R\$ ${formatedCurrency(widget.model.totalPrice)}  ',
                            style: textFamily(
                              context,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).primary,
                            ),
                          ),
                          widget.model.oldPrice != null
                              ? widget.model.oldPrice! > widget.model.totalPrice
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          bottom: wXD(3, context)),
                                      child: Text(
                                        '${getPercentOff()}% OFF',
                                        style: textFamily(
                                          context,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: green,
                                        ),
                                      ),
                                    )
                                  : Container()
                              : Container(),
                        ],
                      ),
                      // Text(
                      //   'em 10 x R\$ ${formatedCurrency(model.totalPrice / 10)} sem juros ',
                      //   style: textFamily(context,
                      //     fontSize: 13,
                      //     fontWeight: FontWeight.w500,
                      //     color: green,
                      //   ),
                      // ),
                      // Option(title: 'Cor', options: ['Preto']),
                      // Option(title: 'Quantidade', options: ['1'], qtd: true),
                      // Option(
                      //   title: 'Armazenamento',
                      //   options: [
                      //     '32 Gb',
                      //     '64 Gb',
                      //     '128 Gb',
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: maxWidth(context),
          padding: EdgeInsets.symmetric(horizontal: wXD(18.5, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: wXD(300, context),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.model.title,
                            style: textFamily(
                              context,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: getColors(context).onBackground,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: wXD(3, context)),
                      FutureBuilder<Map<String, dynamic>>(
                        future: store.getAverageEvaluation(widget.model.id),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return StarsLoadCircular(
                              size: wXD(15, context),
                            );
                          }
                          // num lengthRating = 0;
                          num averageRating = 0;
                          Map<String, dynamic> response = snapshot.data!;
                          // lengthRating = response['length-rating'];
                          // print(response['average-rating']);
                          averageRating = response['average-rating'];
                          return Row(
                            children: [
                              SizedBox(width: wXD(6, context)),
                              RatingBar(
                                initialRating: averageRating.toDouble(),
                                ignoreGestures: true,
                                onRatingUpdate: (value) {},
                                glowColor:
                                    getColors(context).primary.withOpacity(.4),
                                unratedColor:
                                    getColors(context).primary.withOpacity(.4),
                                allowHalfRating: true,
                                itemSize: wXD(15, context),
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star_rounded,
                                      color: getColors(context).primary),
                                  empty: Icon(Icons.star_outline_rounded,
                                      color: getColors(context).primary),
                                  half: Icon(Icons.star_half_rounded,
                                      color: getColors(context).primary),
                                ),
                              ),
                              SizedBox(width: wXD(14, context)),
                              Text(
                                averageRating.toDouble().toString(),
                                style: textFamily(
                                  context,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: getColors(context).primary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  Spacer(),
                  FutureBuilder<Map>(
                    future: widget.model.getIsLiked(),
                    builder: (context, snapshot) {
                      // print('snapshot.hasData getIsLiked: ${snapshot.hasData}');
                      if (!snapshot.hasData) {
                        return Container();
                      }

                      Map response = snapshot.data!;

                      if (liked == null) {
                        liked = response["liked"];
                        likeCount = response["likes"];
                      }

                      return StatefulBuilder(
                        builder: (context, refresh) {
                          return Column(
                            children: [
                              FloatingCircleButton(
                                onTap: () {
                                  print("ONTAP $liked");
                                  refresh(() {
                                    liked = !liked!;
                                    if (liked!) {
                                      likeCount = likeCount! + 1;
                                    } else {
                                      likeCount = likeCount! - 1;
                                    }
                                  });
                                  store.likeAds(widget.model.id, liked!);
                                },
                                size: wXD(29, context),
                                color: getColors(context).surface,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: wXD(2, context)),
                                  child: Icon(
                                    liked!
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    size: wXD(23, context),
                                    color: getColors(context).primary,
                                  ),
                                ),
                              ),
                              Text(
                                '$likeCount',
                                style: textFamily(
                                  context,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: getColors(context).primary,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: wXD(22, context)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Observer(builder: (context) {
                    return Container(
                      width: wXD(50, context),
                      child: Container(
                        margin: EdgeInsets.only(left: wXD(6, context)),
                        height: wXD(21, context),
                        width: wXD(44, context),
                        decoration: BoxDecoration(
                            color: getColors(context).surface.withOpacity(.4),
                            borderRadius: BorderRadius.all(Radius.circular(3))),
                        alignment: Alignment.center,
                        child: Text(
                          '${store.imageIndex} / ${widget.model.images.length}',
                          style: textFamily(
                            context,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: getColors(context).primary,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Container(
                  //   height: wXD(148, context),
                  //   width: wXD(136, context),
                  //   padding: EdgeInsets.only(
                  //     top: wXD(11, context),
                  //     bottom: wXD(15, context),
                  //   ),
                  //   child: SingleChildScrollView(
                  //     controller: scrollController,
                  //     scrollDirection: Axis.horizontal,
                  //     // padding: EdgeInsets.only(right: wXD(10, context)),
                  //     physics: PageScrollPhysics(parent: BouncingScrollPhysics()),
                  //     child: Row(
                  //         children: List.generate(
                  //       widget.model.images.length,
                  //       (index) => Padding(
                  //         padding: EdgeInsets.only(
                  //           left: wXD(10, context),
                  //           right: wXD(10, context),
                  //         ),
                  //         child: CachedNetworkImage(
                  //           imageUrl: widget.model.images[index],
                  //           width: wXD(116, context),
                  //           height: wXD(122, context),
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     )),
                  //   ),
                  // ),
                  // Container(
                  //   height: maxWidth(context),
                  //   width: wXD(50, context),
                  //   alignment: Alignment.bottomRight,
                  //   child: FloatingCircleButton(
                  //     onTap: () {
                  //       store.share();
                  //     },
                  //     size: wXD(29, context),
                  //     color: white,
                  //     child: Padding(
                  //       padding: EdgeInsets.only(
                  //           top: wXD(2, context), right: wXD(2, context)),
                  //       child: Icon(
                  //         Icons.share_outlined,
                  //         size: wXD(23, context),
                  //         color: getColors(context).primary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String getPercentOff() {
    int percent =
        (widget.model.totalPrice / widget.model.oldPrice! * 100).toInt();
    return percent.toString();
  }
}

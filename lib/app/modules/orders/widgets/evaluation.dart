import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/order_model.dart';
import 'package:delivery_customer/app/core/models/rating_model.dart';
import 'package:delivery_customer/app/core/models/time_model.dart';
import 'package:delivery_customer/app/modules/orders/widgets/ads_order_data.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../orders_store.dart';

class Evaluation extends StatefulWidget {
  final Order model;

  Evaluation({Key? key, required this.model}) : super(key: key);
  @override
  _EvaluationState createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  final OrdersStore store = Modular.get();
  final ScrollController scrollControler = ScrollController();

  Map productsRatings = {};
  bool productValidate = false;

  double sellerRating = 0;
  String? sellerOpnion;
  bool sellerValidate = false;
  FocusNode sellerFocus = FocusNode();

  double deliveryRating = 0;
  String? deliveryOpnion;
  bool deliveryValidate = false;
  FocusNode deliveryFocus = FocusNode();

  int? scorefyRating;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    sellerFocus.dispose();
    deliveryFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.loadOverlayEvaluation != null) {
          return !store.loadOverlayEvaluation!.mounted;
        } else {
          return true;
        }
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollControler,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          wXD(16, context),
                          viewPaddingTop(context) + wXD(60, context),
                          wXD(12, context),
                          wXD(12, context),
                        ),
                        width: maxWidth(context),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.2)),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avalie seu pedido',
                              style: textFamily(
                                context,
                                color: black,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              Time(DateTime.now()).dayDate(),
                              style: textFamily(
                                context,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      productsToRating(),
                      TypeEvaluation(
                          onComplete: () => deliveryFocus.requestFocus(),
                          focus: sellerFocus,
                          title: 'O que achou do atendimento do vendedor?',
                          complement: 'do vendedor',
                          validate: sellerValidate,
                          rating: sellerRating,
                          charLength:
                              sellerOpnion == null ? 0 : sellerOpnion!.length,
                          onRatingUpdate: (val) =>
                              setState(() => sellerRating = val),
                          onChanged: (val) => setState(
                                () => val == ''
                                    ? sellerOpnion = null
                                    : sellerOpnion = val,
                              )),
                      TypeEvaluation(
                          onComplete: () => deliveryFocus.unfocus(),
                          focus: deliveryFocus,
                          title: 'O que achou da entrega?',
                          complement: 'da entrega',
                          validate: deliveryValidate,
                          rating: deliveryRating,
                          charLength: deliveryOpnion == null
                              ? 0
                              : deliveryOpnion!.length,
                          onRatingUpdate: (val) =>
                              setState(() => deliveryRating = val),
                          onChanged: (val) => setState(
                                () => val == ''
                                    ? deliveryOpnion = null
                                    : deliveryOpnion = val,
                              )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          wXD(19, context),
                          wXD(12, context),
                          wXD(17, context),
                          wXD(17, context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Avalie a Scorefy também.',
                              style: textFamily(
                                context,
                                color: black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Em uma escala de 0 a 10, qual é a chance de você indicar a Scorefy para um amigo?',
                              style: textFamily(
                                context,
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: wXD(15, context)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              10,
                              (index) => Ball(
                                    index + 1,
                                    scorefyRating,
                                    (numb) =>
                                        setState(() => scorefyRating = numb),
                                  )),
                        ),
                      ),
                      SizedBox(height: wXD(35, context)),
                      SideButton(
                        onTap: () {
                          if (validateRatings()) {
                            Map<String, dynamic> evaluateData = {
                              "sellers": Rating(
                                opnion: sellerOpnion,
                                rating: sellerRating,
                                answered: false,
                                orderId: widget.model.id,
                                evaluatedCollection: "sellers",
                                evaluatedId: widget.model.sellerId,
                                status: "VISIBLE",
                              ),
                              "agents": Rating(
                                opnion: deliveryOpnion,
                                rating: deliveryRating,
                                answered: false,
                                orderId: widget.model.id,
                                evaluatedCollection: "agents",
                                evaluatedId: widget.model.agentId,
                                status: "VISIBLE",
                              ),
                              "scorefy": scorefyRating != null
                                  ? Rating(
                                      rating: scorefyRating!.toDouble(),
                                      evaluatedCollection: "scorefy",
                                      evaluatedId: "scorefy",
                                    )
                                  : null,
                              "ads": [],
                            };
                            productsRatings.forEach((key, value) {
                              evaluateData["ads"].add(
                                Rating(
                                  opnion: productsRatings[key]["opnion"],
                                  rating: productsRatings[key]["rating"],
                                  answered: false,
                                  orderId: widget.model.id,
                                  evaluatedCollection: "ads",
                                  evaluatedId: key,
                                  status: "VISIBLE",
                                ),
                              );
                            });
                            // evaluateData["ads"].forEach((ads) {
                            //   print("ads: ${ads.toJson()}");
                            // });
                            // print("ads: ${evaluateData["ads"]}");
                            // print(
                            //     "sellers: ${evaluateData['sellers'].toJson()}");
                            // print(
                            //     "agents: ${evaluateData['agents'].toJson()}");
                            // print(
                            //     "scorefy: ${evaluateData['scorefy'].toJson()}");
                            // // print("ads: ${evaluateData['ads'].toJson()}");
                            store.evaluate(evaluateData, context);
                          }
                        },
                        height: wXD(52, context),
                        width: wXD(142, context),
                        title: 'Avaliar',
                      ),
                      SizedBox(height: wXD(25, context)),
                    ],
                  ),
                ),
              ),
              DefaultAppBar(
                'Avaliação',
                onPop: () {
                  if (store.loadOverlayEvaluation == null ||
                      !store.loadOverlayEvaluation!.mounted) {
                    Modular.to.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  productsToRating() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("customers")
          .doc(widget.model.customerId)
          .collection("orders")
          .doc(widget.model.id)
          .collection("ads")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: maxWidth(context),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: wXD(20, context)),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(getColors(context).primary),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: snapshot.data!.docs.map((subAdsDoc) {
            if (!productsRatings.containsKey(subAdsDoc.id)) {
              productsRatings[subAdsDoc.id] = {
                "rating": 5.0,
                "opnion": "",
              };
            }
            return Column(
              children: [
                AdsOrderData(
                  adsDoc: subAdsDoc,
                  totalItems: subAdsDoc["amount"],
                ),
                TypeEvaluation(
                  title: 'Você gostou do produto?',
                  complement: 'do produto',
                  rating: productsRatings[subAdsDoc.id]["rating"],
                  charLength: productsRatings[subAdsDoc.id]["opnion"] == null
                      ? 0
                      : productsRatings[subAdsDoc.id]["opnion"]
                          .toString()
                          .length,
                  onRatingUpdate: (val) => setState(() {
                    productsRatings[subAdsDoc.id]["rating"] = val;
                    // print(
                    //     "productRating: ${productsRatings[subAdsDoc.id]["rating"]}");
                  }),
                  onChanged: (val) => setState(
                    () => productsRatings[subAdsDoc.id]["opnion"] = val,
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  adsOrderDataSkeleton(context) => Column(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: wXD(10, context), left: wXD(22, context)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: wXD(65, context),
                  width: wXD(62, context),
                  child: LinearProgressIndicator(
                    backgroundColor: lightGrey.withOpacity(.6),
                    valueColor: AlwaysStoppedAnimation(veryLightGrey),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: wXD(8, context)),
                      width: wXD(220, context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: wXD(3, context)),
                          Container(
                            height: wXD(14, context),
                            width: wXD(130, context),
                            child: LinearProgressIndicator(
                              backgroundColor: lightGrey.withOpacity(.6),
                              valueColor: AlwaysStoppedAnimation(veryLightGrey),
                            ),
                          ),
                          SizedBox(height: wXD(3, context)),
                          Container(
                            height: wXD(14, context),
                            width: wXD(130, context),
                            child: LinearProgressIndicator(
                              backgroundColor: lightGrey.withOpacity(.6),
                              valueColor: AlwaysStoppedAnimation(veryLightGrey),
                            ),
                          ),
                          SizedBox(height: wXD(3, context)),
                          Container(
                            height: wXD(14, context),
                            width: wXD(130, context),
                            child: LinearProgressIndicator(
                              backgroundColor: lightGrey.withOpacity(.6),
                              valueColor: AlwaysStoppedAnimation(veryLightGrey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: wXD(10, context)),
                    Icon(
                      Icons.arrow_forward,
                      size: wXD(14, context),
                      color: grey.withOpacity(.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  bool validateRatings() {
    setState(() {
      // productRating == 0 ? productValidate = true : productValidate = false;
      sellerRating == 0 ? sellerValidate = true : sellerValidate = false;
      deliveryRating == 0 ? deliveryValidate = true : deliveryValidate = false;
    });

    if (productValidate || sellerValidate || deliveryValidate) {
      showToast("Defina todas as avaliações para continuar");
      scrollControler.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCirc,
      );
      return false;
    } else if (!_formKey.currentState!.validate()) {
      showToast("Cada opinião não pode ultrapassar 300 caracteres!");
      return false;
    } else {
      return true;
    }
  }
}

class Ball extends StatelessWidget {
  final int number;
  final int? numberSelected;
  final void Function(int) onTap;

  Ball(
    this.number,
    this.numberSelected,
    this.onTap,
  );

  @override
  Widget build(BuildContext context) {
    // print("$number == $numberSelected");
    return GestureDetector(
      onTap: () => onTap(number),
      child: Container(
        height: wXD(26, context),
        width: wXD(26, context),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: number == numberSelected
                ? getColors(context).primary.withOpacity(.60)
                : getColors(context).primary.withOpacity(.15)),
        alignment: Alignment.center,
        child: Text(
          number.toString(),
          style: textFamily(
            context,
            fontSize: 16,
            color: getColors(context).onBackground,
          ),
        ),
      ),
    );
  }
}

class TypeEvaluation extends StatelessWidget {
  final String title;
  final double rating;
  final int charLength;
  final bool validate;
  final String complement;
  final FocusNode? focus;
  final void Function()? onComplete;
  final void Function(double) onRatingUpdate;
  final void Function(String)? onChanged;

  TypeEvaluation({
    required this.title,
    this.focus,
    required this.rating,
    this.validate = false,
    this.onComplete,
    required this.charLength,
    required this.complement,
    required this.onChanged,
    required this.onRatingUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        wXD(16, context),
        wXD(12, context),
        wXD(16, context),
        wXD(21, context),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onBackground.withOpacity(.2)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textFamily(
              context,
              color: black,
              fontSize: 14,
            ),
          ),
          Text(
            'Escolha de 1 a 5 estrelas para classificar.',
            style: textFamily(
              context,
              color: getColors(context).onBackground.withOpacity(.6),
              fontSize: 12,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: wXD(15, context)),
          RatingBar(
            minRating: 1,
            initialRating: rating,
            onRatingUpdate: onRatingUpdate,
            glowColor: getColors(context).primary.withOpacity(.4),
            unratedColor: getColors(context).primary.withOpacity(.4),
            allowHalfRating: true,
            itemSize: wXD(35, context),
            ratingWidget: RatingWidget(
              full: Icon(Icons.star_rounded, color: getColors(context).primary),
              empty: Icon(Icons.star_outline_rounded,
                  color: getColors(context).primary),
              half: Icon(Icons.star_half_rounded,
                  color: getColors(context).primary),
            ),
          ),
          SizedBox(height: wXD(14, context)),
          validate
              ? Text("Defina a sua avaliação $complement",
                  style: textFamily(
                    context,
                    color: red,
                  ))
              : Container(),
          SizedBox(height: wXD(14, context)),
          Row(
            children: [
              Text(
                'Deixar uma opinião',
                style: textFamily(
                  context,
                  color: black,
                  fontSize: 14,
                ),
              ),
              Spacer(),
              Text(
                '$charLength/300',
                style: textFamily(
                  context,
                  color: getColors(context).onBackground.withOpacity(.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Container(
            // height: wXD(52, context),
            width: wXD(343, context),
            decoration: BoxDecoration(
                border: Border.all(
                    color: getColors(context).primary.withOpacity(.65)),
                borderRadius: BorderRadius.all(Radius.circular(11))),
            margin: EdgeInsets.only(top: wXD(16, context)),
            padding: EdgeInsets.symmetric(
                horizontal: wXD(10, context), vertical: wXD(13, context)),
            alignment: Alignment.topLeft,
            child: TextFormField(
              onEditingComplete: onComplete,
              focusNode: focus,
              validator: (val) {
                if (val != null && val.length > 300) {
                  return "Sua opinião não pode ultrapassar 300 caracteres!";
                } else {
                  return null;
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration.collapsed(
                hintText: 'Deixe sua opinião a respeito $complement',
                hintStyle: textFamily(
                  context,
                  color: getColors(context).onBackground.withOpacity(.55),
                  fontWeight: FontWeight.w400,
                ),
              ),
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}

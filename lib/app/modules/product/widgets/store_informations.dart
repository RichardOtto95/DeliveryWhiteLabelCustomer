import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/seller_model.dart';
import 'package:delivery_customer/app/modules/product/product_store.dart';
import 'package:delivery_customer/app/modules/product/widgets/question.dart';
import 'package:delivery_customer/app/modules/product/widgets/see_all_button.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class StoreInformations extends StatelessWidget {
  final String sellerId;
  final String adsId;

  StoreInformations({
    Key? key,
    required this.sellerId,
    required this.adsId,
  }) : super(key: key);

  final ProductStore store = Modular.get();

  @override
  Widget build(context) {
    TextEditingController textController = TextEditingController();
    String? question;
    // print('sellerIdsellerIdsellerId $sellerId');
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: getColors(context).onBackground.withOpacity(.2))),
      ),
      padding: EdgeInsets.only(bottom: wXD(29, context)),
      child: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sellerId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              Seller sellerModel = Seller.fromDoc(snapshot.data!);
              return Container(
                width: maxWidth(context),
                padding: EdgeInsets.only(
                  top: wXD(27, context),
                  left: wXD(24, context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações da loja',
                      style: textFamily(
                        context,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: getColors(context).onBackground,
                      ),
                    ),
                    SizedBox(height: wXD(6, context), width: wXD(3, context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: wXD(3, context),
                        ),
                        Container(
                          height: wXD(51, context),
                          width: wXD(54, context),
                          color:
                              getColors(context).onBackground.withOpacity(.3),
                          margin: EdgeInsets.only(right: wXD(9, context)),
                          child: sellerModel.avatar == null
                              ? Container(
                                  color: getColors(context).primary,
                                  width: wXD(116, context),
                                  height: wXD(122, context),
                                )
                              : CachedNetworkImage(
                                  imageUrl: sellerModel.avatar!,
                                  width: wXD(116, context),
                                  height: wXD(122, context),
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, label, downloadProgress) {
                                    // print(
                                    //     'progressIndicatorBuilder downloadprogress: $downloadProgress');
                                    return CircularProgressIndicator();
                                  },
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sellerModel.storeName ?? "Sem nome",
                              style: textFamily(
                                context,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: getColors(context).onBackground,
                              ),
                            ),
                            Text(
                              sellerModel.storeCategory ?? "Sem categoria",
                              style: textFamily(
                                context,
                                height: 1.6,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: getColors(context).onSurface,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Descrição',
                        style: textFamily(
                          context,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wXD(3, context)),
                      child: Text(
                        sellerModel.storeDescription ?? "Sem descrição",
                        style: textFamily(
                          context,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Devolução grátis',
                        style: textFamily(
                          context,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wXD(3, context)),
                      child: Text(
                        sellerModel.returnPolicies ??
                            "Sem políticas de devolução grátis",
                        style: textFamily(
                          context,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(10, context)),
                      child: Text(
                        'Garantia',
                        style: textFamily(
                          context,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: wXD(3, context)),
                      child: Padding(
                        padding: EdgeInsets.only(left: wXD(3, context)),
                        child: Text(
                          sellerModel.warranty ?? "Sem termos de garantia",
                          style: textFamily(
                            context,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: getColors(context).onBackground,
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       top: wXD(23, context), bottom: wXD(10, context)),
                    //   child: Text(
                    //     'Forma de pagamento',
                    //     style: textFamily(
                    //       context,
                    //       fontSize: 17,
                    //       fontWeight: FontWeight.w600,
                    //       color: getColors(context).onBackground,
                    //     ),
                    //   ),
                    // ),
                    // Text(
                    //   sellerModel.paymentMethod ??
                    //       "Sem formas de pagamento informadas",
                    //   style: textFamily(
                    //     context,
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: getColors(context).onBackground,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: wXD(23, context), bottom: wXD(21, context)),
                      child: Text(
                        'Perguntas e respostas',
                        style: textFamily(
                          context,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: getColors(context).onBackground,
                        ),
                      ),
                    ),
                    Container(
                      height: wXD(52, context),
                      width: wXD(332, context),
                      padding:
                          EdgeInsets.symmetric(horizontal: wXD(17, context)),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                getColors(context).primary.withOpacity(.65)),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: textController,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onChanged: (val) => question = val,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Faça sua pergunta...',
                          hintStyle: textFamily(context,
                              fontSize: 14,
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.55),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(height: wXD(13, context)),
                    SideButton(
                      onTap: () async {
                        await store.toAsk(question, adsId, context);
                        question = null;
                        textController.clear();
                      },
                      title: 'Enviar',
                      width: wXD(85, context),
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("ads")
                          .doc(adsId)
                          .collection("questions")
                          .orderBy("created_at", descending: true)
                          .limit(5)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: wXD(12, context)),
                                child: Text(
                                  'Mais recentes',
                                  style: textFamily(
                                    context,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: getColors(context).onBackground,
                                  ),
                                ),
                              ),
                              ...snapshot.data!.docs
                                  .map((questionDoc) => Question(
                                        answeredAt:
                                            questionDoc['answered_at'],
                                        question: questionDoc['question'],
                                        answer: questionDoc['answer'],
                                      ))
                                  .toList(),
                              SizedBox(height: wXD(13, context)),
                              snapshot.data!.docs.length >= 5
                                  ? SeeAllButton(
                                      title: 'Ver todas as perguntas',
                                      onTap: () => Modular.to.pushNamed(
                                          '/product/questions',
                                          arguments: adsId))
                                  : Container(),
                            ]);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/orders/widgets/ads_order_data.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import '../orders_store.dart';

class OrderWidget extends StatelessWidget {
  final OrdersStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final DocumentSnapshot orderDoc;
  User _user = FirebaseAuth.instance.currentUser!;

  OrderWidget({
    Key? key,
    required this.orderDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("customers")
          .doc(_user.uid)
          .collection("orders")
          .doc(orderDoc.id)
          .collection("ads")
          .get(),
      builder: (context, adsSnap) {
        if (!adsSnap.hasData) {
          return orderSkeleton(context);
        }
        final adsDoc = adsSnap.data!.docs.first;
        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: wXD(6, context),
                  left: wXD(4, context),
                  top: wXD(20, context),
                ),
                child: Text(
                  getOrderDate(adsDoc['created_at'].toDate()),
                  style: textFamily(
                    context,
                    fontSize: 14,
                    color: getColors(context).onSurface,
                  ),
                ),
              ),
              Container(
                height: wXD(157, context),
                width: wXD(352, context),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffF1F1F1)),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: getColors(context).surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      offset: Offset(0, 3),
                      color: getColors(context).shadow,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        store.adsId = adsDoc.id;
                        await Modular.to.pushNamed('/orders/shipping-details',
                            arguments: {
                              "id": adsDoc['order_id'],
                              "itemsQue": adsSnap.data!.docs
                            });
                      },
                      child: AdsOrderData(
                        adsDoc: adsDoc,
                        totalItems: orderDoc["total_amount"],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: wXD(20, context)),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 9,
                            child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  Modular.to.pushNamed('/support');
                                },
                                child: Text(
                                  'Suporte',
                                  style: textFamily(context,
                                      color: getColors(context).primary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () async {
                                  print('adsDoc["id"]: ${adsDoc["id"]}');
                                  await mainStore.viewProduct(adsDoc["id"]);
                                },
                                child: Text(
                                  'Visualizar produto',
                                  style: textFamily(context,
                                      color: getColors(context).primary),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String getOrderDate(DateTime date) {
    String strDate = '';

    String weekDay = DateFormat('EEEE').format(date);

    String month = DateFormat('MMMM').format(date);

    strDate =
        "${weekDay.substring(0, 1).toUpperCase()}${weekDay.substring(1, 3)} ${date.day} $month ${date.year}";

    return strDate + " - " + getPortugueseStatus(orderDoc.get("status"));
  }

  orderSkeleton(context) => Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: wXD(6, context),
                left: wXD(4, context),
                top: wXD(20, context),
              ),
              child: Container(
                height: wXD(14, context),
                width: wXD(100, context),
                child: LinearProgressIndicator(
                  backgroundColor: lightGrey.withOpacity(.6),
                  valueColor: AlwaysStoppedAnimation(veryLightGrey),
                ),
              ),
            ),
            Container(
              height: wXD(140, context),
              width: wXD(352, context),
              decoration: BoxDecoration(
                border: Border.all(color: getColors(context).surface),
                borderRadius: BorderRadius.all(Radius.circular(3)),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    color: getColors(context).shadow,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.2)))),
                    padding: EdgeInsets.only(bottom: wXD(7, context)),
                    margin: EdgeInsets.fromLTRB(
                      wXD(19, context),
                      wXD(18, context),
                      wXD(15, context),
                      wXD(0, context),
                    ),
                    alignment: Alignment.center,
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
                                      backgroundColor:
                                          lightGrey.withOpacity(.6),
                                      valueColor:
                                          AlwaysStoppedAnimation(veryLightGrey),
                                    ),
                                  ),
                                  SizedBox(height: wXD(3, context)),
                                  Container(
                                    height: wXD(14, context),
                                    width: wXD(130, context),
                                    child: LinearProgressIndicator(
                                      backgroundColor:
                                          lightGrey.withOpacity(.6),
                                      valueColor:
                                          AlwaysStoppedAnimation(veryLightGrey),
                                    ),
                                  ),
                                  SizedBox(height: wXD(3, context)),
                                  Container(
                                    height: wXD(14, context),
                                    width: wXD(130, context),
                                    child: LinearProgressIndicator(
                                      backgroundColor:
                                          lightGrey.withOpacity(.6),
                                      valueColor:
                                          AlwaysStoppedAnimation(veryLightGrey),
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
                  Spacer(),
                  Row(
                    children: [
                      SizedBox(width: wXD(45, context)),
                      Container(
                        height: wXD(14, context),
                        width: wXD(70, context),
                        child: LinearProgressIndicator(
                          backgroundColor: lightGrey.withOpacity(.6),
                          valueColor: AlwaysStoppedAnimation(veryLightGrey),
                        ),
                      ),
                      // SizedBox(width: wXD(75, context)),
                      Spacer(),
                      Container(
                        height: wXD(14, context),
                        width: wXD(70, context),
                        child: LinearProgressIndicator(
                          backgroundColor: lightGrey.withOpacity(.6),
                          valueColor: AlwaysStoppedAnimation(veryLightGrey),
                        ),
                      ),
                      SizedBox(width: wXD(45, context)),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      );
}

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
// import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'accounts.dart';

class FinalizingOrder extends StatefulWidget {
  final bool paymentMethodIsPix;

  const FinalizingOrder({
    Key? key,
    required this.paymentMethodIsPix,
  }) : super(key: key);

  @override
  _FinalizingOrderState createState() => _FinalizingOrderState();
}

class _FinalizingOrderState extends State<FinalizingOrder> {
  final CartStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  Timer? timer;
  bool paid = false;
  User _user = FirebaseAuth.instance.currentUser!;
  MapZoomPanBehavior mapZoomPanBehavior = MapZoomPanBehavior(
    zoomLevel: 5,
    enableDoubleTapZooming: true,
    focalLatLng: MapLatLng(-15.787763, -48.008072),
  );

  @override
  void initState() {
    print('initstate finalizingorder');
    if (!widget.paymentMethodIsPix) {
      setTimer();
    }

    super.initState();
  }

  setTimer() {
    if (timer == null) {
      store.seconstToFinalize = 5;
      timer = Timer.periodic(Duration(seconds: 1), (_timer) {
        if (_timer.tick == 6) {
          store.finalizeOrder(context);
          timer!.cancel();
        }
        setState(() {
          store.seconstToFinalize = 6 - _timer.tick;          
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.loadOverlay != null && store.loadOverlay!.mounted) {
          return false;
        } else {
          // if(timer != null){
          //   timer!.cancel();
          // }
          if (widget.paymentMethodIsPix && !paid) {
            return true;
          }

          return false;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: widget.paymentMethodIsPix && !paid
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        wXD(19, context),
                        wXD(40, context),
                        wXD(15, context),
                        wXD(32, context),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Para finalizar o pedido, faça o pix',
                            style: textFamily(
                              context,
                              fontSize: 18,
                              color: Color(0xff241332),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      brightness == Brightness.light
                          ? "./assets/images/logo.png"
                          : "./assets/images/logo_dark.png",
                      width: wXD(193, context),
                      height: wXD(173, context),
                    ),
                    FutureBuilder<List<num>>(
                        future: store.getSubTotal(),
                        //           child: Column(
                        //             children: [
                        //               Text(
                        //                 'Quase pronto',
                        //                 style: textFamily(context,
                        //                   fontSize: 15,
                        //                   color: darkGrey,
                        //                 ),
                        //               ),
                        //               Text(
                        //                 'Agora só falta fazer o pix no valor de: R\$ ' + formatedCurrency(price) + ", chave pix: cnpj.",
                        //                 style: textFamily(context,
                        //                   fontSize: 15,
                        //                   color: darkGrey,
                        //                 ),
                        //               ),
                        //               SizedBox(
                        //                 height: 40,
                        //               ),
                        //               TextButton(
                        //                 onPressed: (){
                        //                   Clipboard.setData(ClipboardData(text: '29.412.420/0001-67')).then((value) {
                        //                     showToast('Chave copiada');
                        //                     // ScaffoldMessenger.of(context).showSnackBar(
                        //                     //   SnackBar(
                        //                     //     content: Container(
                        //                     //       color: darkGrey,
                        //                     //       child: Text(
                        //                     //         'Chave copiada',
                        //                     //         style: textFamily(context,
                        //                     //           fontSize: 20,
                        //                     //           color: primary,
                        //                     //         ),
                        //                     //       ),
                        //                     //     ),

                        //                     //   ),
                        //                     // );
                        //                   });
                        //                 },
                        //                 child: Column(
                        //                   // mainAxisAlignment: MainAxisAlignment.center,
                        //                   crossAxisAlignment: CrossAxisAlignment.center,
                        //                   children: [
                        //                     Text(
                        //                       '29.412.420/0001-67',
                        //                       style: textFamily(context,
                        //                         fontSize: 20,
                        //                         color: darkGrey,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       'Pressione aqui para copiar',
                        //                       style: textFamily(context,
                        //                         fontSize: 10,
                        //                         color: primaryLight,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       }
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.symmetric(vertical: wXD(50, context)),
                        //       // width: maxWidth(context),
                        //       alignment: Alignment.centerRight,
                        //       child: SideButton(
                        //         onTap: () {
                        //           setState(() {
                        //             paid = true;
                        //             setTimer();
                        //           });
                        //         },
                        //         title: 'Paguei',
                        //         width: wXD(122, context),
                        //       ),
                        //     )
                        //   ],
                        // ) : Column(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.fromLTRB(
                        //         wXD(19, context),
                        //         wXD(40, context),
                        //         wXD(15, context),
                        //         wXD(32, context),
                        //       ),
                        //       child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Observer(
                        //             builder: (context) {
                        //               return Text(
                        //                 'Finalizando pedido em: ${store.seconstToFinalize}',
                        //                 style: textFamily(context,
                        //                   fontSize: 20,
                        //                   color: colors.onBackground,
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     Container(
                        //       decoration: BoxDecoration(
                        //           border: Border(
                        //               bottom: BorderSide(
                        //                   color: colors.onBackground.withOpacity(.2)))),
                        //       padding: EdgeInsets.fromLTRB(
                        //         wXD(19, context),
                        //         0,
                        //         wXD(25, context),
                        //         wXD(26, context),
                        //       ),
                        //       child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        //         future: FirebaseFirestore.instance
                        //             .collection("customers")
                        //             .doc(_user.uid)
                        //             .get(),
                        //         builder: (context, snapshot) {
                        //           if (!snapshot.hasData) {
                        //             return Container();
                        //           }
                        //           return StreamBuilder<
                        //               DocumentSnapshot<Map<String, dynamic>>>(
                        //             stream: snapshot.data!.reference
                        //                 .collection("addresses")
                        //                 .doc(snapshot.data!.get("main_address"))
                        //                 .snapshots(),
                        //             builder: (context, addressSnap) {
                        //               if (!addressSnap.hasData) {
                        //                 return getAddressEmpty(context);
                        //               }
                        //               Address address =
                        //                   Address.fromDoc(addressSnap.data!);
                        //               WidgetsBinding.instance
                        //                   .addPostFrameCallback((timeStamp) {
                        //                 store.addressId = address.id!;
                        //               });
                        //               mapZoomPanBehavior.focalLatLng = MapLatLng(address.latitude!, address.longitude!);
                        //               mapZoomPanBehavior.zoomLevel = 8;
                        //               return Row(
                        //                 crossAxisAlignment: CrossAxisAlignment.center,
                        //                 children: [
                        //                   Icon(
                        //                     Icons.check,
                        //                     size: wXD(24, context),
                        //                     color: colors.primary,
                        //                   ),
                        //                   SizedBox(width: wXD(15, context)),
                        //                   ClipRRect(
                        //                     borderRadius:
                        //                         BorderRadius.all(Radius.circular(10)),
                        //                     child: Container(
                        //                       width: wXD(62, context),
                        //                       height: wXD(47, context),
                        //                       color: Colors.grey,
                        //                       child: SfMaps(
                        //                         layers: [
                        //                           MapTileLayer(
                        //                             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        //                             zoomPanBehavior: mapZoomPanBehavior,
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       // child: GoogleMap(
                        //                       //   initialCameraPosition: CameraPosition(
                        //                       //       zoom: 5,
                        //                       //       target: LatLng(
                        //                       //         address.latitude!,
                        //                       //         address.longitude!,
                        //                       //       )),
                        //                       //   scrollGesturesEnabled: false,
                        //                       //   mapToolbarEnabled: false,
                        //                       //   zoomControlsEnabled: false,
                        //                       //   zoomGesturesEnabled: false,
                        //                       //   compassEnabled: false,
                        //                       // ),
                        //                     ),
                        //                   ),
                        //                   SizedBox(width: wXD(14, context)),
                        //                   Container(
                        //                     width: wXD(215, context),
                        //                     child: Text(
                        //                       address.formatedAddress!,
                        //                       style: textFamily(context,height: 1.4),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               );
                        //             },
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //     Column(
                        //       children: mainStore.cartObj
                        //           .map(
                        //             (cartItem) => StreamBuilder<DocumentSnapshot>(
                        //               stream: FirebaseFirestore.instance
                        //                   .collection("ads")
                        //                   .doc(cartItem.adsId)
                        //                   .snapshots(),
                        builder: (context, snapshot) {
                          num price = 0;
                          if (snapshot.hasData) {
                            price = snapshot.data![4];
                          }
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              wXD(19, context),
                              wXD(40, context),
                              wXD(15, context),
                              wXD(32, context),
                            ),
                            child: Column(
                              children: [
                                // Icon(
                                //   Icons.check,
                                //   size: wXD(24, context),
                                //   color: getColors(context).primary,
                                // ),
                                // SizedBox(width: wXD(15, context)),
                                // ClipRRect(
                                //   child: CachedNetworkImage(
                                //     imageUrl: item['images'].first,
                                //     width: wXD(62, context),
                                //     height: wXD(65, context),
                                //     fit: BoxFit.cover,
                                Text(
                                  'Quase pronto',
                                  style: textFamily(
                                    context,
                                    fontSize: 15,
                                    color: getColors(context).onBackground,
                                  ),
                                ),
                                Text(
                                  'Agora só falta fazer o pix no valor de: R\$' +
                                      formatedCurrency(price) +
                                      ", chave pix: cnpj.",
                                  style: textFamily(
                                    context,
                                    fontSize: 15,
                                    color: getColors(context).onBackground,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                            text: '29.412.420/0001-67'))
                                        .then((value) {
                                      showToast('Chave copiada');
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(
                                      //     content: Container(
                                      //       color: darkGrey,
                                      //       child: Text(
                                      //         'Chave copiada',
                                      //         style: textFamily(context,
                                      //           fontSize: 20,
                                      //           color: primary,
                                      //         ),
                                      //       ),
                                      //     ),

                                      //   ),
                                      // );
                                    });
                                  },
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '29.412.420/0001-67',
                                        style: textFamily(
                                          context,
                                          fontSize: 20,
                                          color:
                                              getColors(context).onBackground,
                                        ),
                                      ),
                                      Text(
                                        'Pressione aqui para copiar',
                                        style: textFamily(
                                          context,
                                          fontSize: 10,
                                          color: getColors(context).primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: wXD(50, context)),
                      // width: maxWidth(context),
                      alignment: Alignment.centerRight,
                      child: SideButton(
                        onTap: () {
                          setState(() {
                            paid = true;
                            setTimer();
                          });
                        },
                        title: 'Paguei',
                        width: wXD(122, context),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        wXD(19, context),
                        wXD(40, context),
                        wXD(15, context),
                        wXD(32, context),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Observer(
                            builder: (context) {
                              return Text(
                                'Finalizando pedido em: ${store.seconstToFinalize}',
                                style: textFamily(
                                  context,
                                  fontSize: 20,
                                  color: getColors(context).onBackground,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: getColors(context)
                                      .onBackground
                                      .withOpacity(.2)))),
                      padding: EdgeInsets.fromLTRB(
                        wXD(19, context),
                        0,
                        wXD(25, context),
                        wXD(26, context),
                      ),
                      child:
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection("customers")
                            .doc(_user.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: snapshot.data!.reference
                                .collection("addresses")
                                .doc(snapshot.data!.get("main_address"))
                                .snapshots(),
                            builder: (context, addressSnap) {
                              if (!addressSnap.hasData) {
                                return getAddressEmpty(context);
                              }
                              Address address =
                                  Address.fromDoc(addressSnap.data!);
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                store.addressId = address.id!;
                              });
                              mapZoomPanBehavior.focalLatLng = MapLatLng(
                                  address.latitude!, address.longitude!);
                              mapZoomPanBehavior.zoomLevel = 8;
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: wXD(24, context),
                                    color: getColors(context).primary,
                                  ),
                                  SizedBox(width: wXD(15, context)),
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Container(
                                      width: wXD(62, context),
                                      height: wXD(47, context),
                                      color: Colors.grey,
                                      child: SfMaps(
                                        layers: [
                                          MapTileLayer(
                                            urlTemplate:
                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            zoomPanBehavior: mapZoomPanBehavior,
                                          ),
                                        ],
                                      ),
                                      // child: GoogleMap(
                                      //   initialCameraPosition: CameraPosition(
                                      //       zoom: 5,
                                      //       target: LatLng(
                                      //         address.latitude!,
                                      //         address.longitude!,
                                      //       )),
                                      //   scrollGesturesEnabled: false,
                                      //   mapToolbarEnabled: false,
                                      //   zoomControlsEnabled: false,
                                      //   zoomGesturesEnabled: false,
                                      //   compassEnabled: false,
                                      // ),
                                    ),
                                  ),
                                  SizedBox(width: wXD(14, context)),
                                  Container(
                                    width: wXD(215, context),
                                    child: Text(
                                      address.formatedAddress!,
                                      style: textFamily(context, height: 1.4),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Column(
                      children: store.cartList
                          .map(
                            (adsId) => StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("ads")
                                  .doc(adsId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: wXD(100, context),
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          getColors(context).primary),
                                    ),
                                  );
                                }

                                DocumentSnapshot item = snapshot.data!;
                                return Container(
                                  width: maxWidth(context),
                                  padding: EdgeInsets.only(
                                    left: wXD(19, context),
                                    bottom: wXD(12, context),
                                  ),
                                  margin:
                                      EdgeInsets.only(top: wXD(15, context)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: wXD(24, context),
                                        color: getColors(context).primary,
                                      ),
                                      SizedBox(width: wXD(15, context)),
                                      ClipRRect(
                                        child: CachedNetworkImage(
                                          imageUrl: item['images'].first,
                                          width: wXD(62, context),
                                          height: wXD(65, context),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: wXD(8, context)),
                                        width: wXD(250, context),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              style: textFamily(context,
                                                  color: getColors(context)
                                                      .onBackground),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: wXD(3, context)),
                                            Text(
                                              item['description'],
                                              style: textFamily(context,
                                                  color: getColors(context)
                                                      .onSurface),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: wXD(3, context)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.2)),
                          top: BorderSide(
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.2)),
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        wXD(19, context),
                        wXD(18, context),
                        wXD(0, context),
                        wXD(16, context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check,
                                size: wXD(24, context),
                                color: getColors(context).primary,
                              ),
                              SizedBox(width: wXD(15, context)),
                              SizedBox(width: wXD(14, context)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    store.foreCast(),
                                    style: textFamily(context,
                                        color: getColors(context).onBackground),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: wXD(3, context)),
                                  Text(
                                    'Previsão de chegada',
                                    style: textFamily(context,
                                        color: getColors(context).onSurface),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: wXD(3, context)),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    FutureBuilder<List<num>>(
                      future: store.getSubTotal(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            height: wXD(120, context),
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  getColors(context).primary),
                            ),
                          );
                        }
                        return Column(
                          children: [
                            Accounts(
                              subTotal: snapshot.data![0],
                              priceShipping: snapshot.data![1],
                              priceTotal: snapshot.data![2],
                              discount: snapshot.data![3],
                              newPriceTotal: snapshot.data![4],
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                right: wXD(20, context),
                                left: wXD(30, context),
                                bottom:
                                    store.change == 0 ? wXD(15, context) : 0,
                              ),
                              decoration: store.change == 0
                                  ? BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onBackground
                                                .withOpacity(.2)),
                                      ),
                                    )
                                  : null,
                              child: Row(
                                children: [
                                  Text(
                                    'Método de pagamento',
                                    style: textFamily(
                                      context,
                                      fontSize: 15,
                                      color: getColors(context)
                                          .onBackground
                                          .withOpacity(.7),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    store.paymentMethod,
                                    style: textFamily(
                                      context,
                                      fontSize: 15,
                                      color: getColors(context).primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            store.change == 0
                                ? Container()
                                : Container(
                                    padding: EdgeInsets.only(
                                      right: wXD(20, context),
                                      left: wXD(30, context),
                                      bottom: wXD(15, context),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: getColors(context)
                                                .onBackground
                                                .withOpacity(.2)),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Troco',
                                          style: textFamily(
                                            context,
                                            fontSize: 15,
                                            color:
                                                getColors(context).onBackground,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          'R\$ ${formatedCurrency(store.change)}',
                                          style: textFamily(
                                            context,
                                            fontSize: 15,
                                            color: getColors(context).primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: wXD(50, context)),
                      width: maxWidth(context),
                      alignment: Alignment.centerRight,
                      child: SideButton(
                        onTap: () {
                          if (store.loadOverlay == null ||
                              !store.loadOverlay!.mounted) {
                            timer!.cancel();
                            Modular.to.pop();
                          }
                        },
                        title: 'Desfazer',
                        width: wXD(122, context),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget getAddressEmpty(context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            width: wXD(62, context),
            height: wXD(47, context),
            color: getColors(context).onSurface,
          ),
        ),
        SizedBox(width: wXD(14, context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: wXD(12, context),
              width: wXD(130, context),
              child: LinearProgressIndicator(
                backgroundColor: getColors(context).primary.withOpacity(.3),
                color: getColors(context).primary.withOpacity(.8),
              ),
            ),
            SizedBox(height: wXD(5, context)),
            Container(
              height: wXD(12, context),
              width: wXD(150, context),
              child: LinearProgressIndicator(
                backgroundColor: getColors(context).primary.withOpacity(.3),
                color: getColors(context).primary.withOpacity(.8),
              ),
            ),
            SizedBox(height: wXD(5, context)),
            Container(
              height: wXD(12, context),
              width: wXD(140, context),
              child: LinearProgressIndicator(
                backgroundColor: getColors(context).primary.withOpacity(.3),
                color: getColors(context).primary.withOpacity(.8),
              ),
            ),
          ],
        ),
        Spacer(),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_forward,
            size: wXD(20, context),
            color: getColors(context).primary,
          ),
        )
      ],
    );
  }
}

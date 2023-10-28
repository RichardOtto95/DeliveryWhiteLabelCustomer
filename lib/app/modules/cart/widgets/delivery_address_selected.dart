import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

// ignore: must_be_immutable
class DeliveryAddressSelected extends StatelessWidget {
  final void Function() onTap;
  DeliveryAddressSelected({Key? key, required this.onTap}) : super(key: key);
  final MainStore mainStore = Modular.get();
  final CartStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (mainStore.customer == null) {
          return Container();
        }
        if (mainStore.customer!.mainAddress == null) {
          return Container();
        }
        store.addressId = mainStore.customer!.id;
        print("customer: ${mainStore.customer!.toJson()}");
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("customers")
              .doc(mainStore.customer!.id)
              .collection("addresses")
              .doc(mainStore.customer!.mainAddress)
              .snapshots(),
          builder: (context, addressSnap) {
            // print('addressSnap.hasData: ${addressSnap.hasData}');
            if (!addressSnap.hasData) {
              return getAddressEmpty(context);
            }
            store.address = Address.fromDoc(addressSnap.data!);

            store.zoomPanBehavior.focalLatLng =
                MapLatLng(store.address!.latitude!, store.address!.longitude!);

            if (store.marker.isEmpty) {
              store.marker.add(MapMarker(
                latitude: store.address!.latitude!,
                longitude: store.address!.longitude!,
                child: Icon(
                  Icons.location_on,
                  color: getColors(context).primary,
                ),
              ));
            } else {
              store.marker[0] = MapMarker(
                latitude: store.address!.latitude!,
                longitude: store.address!.longitude!,
                child: Icon(
                  Icons.location_on,
                  color: getColors(context).primary,
                ),
              );
            }

            store.zoomPanBehavior.zoomLevel = 15;
            print(
                "store.mapTileLayerController!.markersCount: ${store.mapTileLayerController.markersCount}");

            if (store.mapTileLayerController.markersCount == 0) {
              store.mapTileLayerController.insertMarker(0);
            } else {
              store.mapTileLayerController.updateMarkers([0]);
            }

            return InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: getColors(context)
                                .onBackground
                                .withOpacity(.2)))),
                padding: EdgeInsets.fromLTRB(18, 20, 25, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Endereço de entrega',
                      style: textFamily(
                        context,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: getColors(context).onSurface,
                      ),
                    ),
                    SizedBox(height: wXD(10, context)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          child: SizedBox(
                            width: wXD(120, context),
                            height: wXD(80, context),
                            child: SfMaps(
                              layers: [
                                MapTileLayer(
                                  controller: store.mapTileLayerController,
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  zoomPanBehavior: store.zoomPanBehavior,
                                  markerBuilder:
                                      (BuildContext context, int index) {
                                    return store.marker[index];
                                  },
                                  initialMarkersCount: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: wXD(10, context)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: wXD(180, context),
                              child: Text(store.address!.formatedAddress!,
                                  style: textFamily(context, height: 1.4)),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward,
                          size: wXD(20, context),
                          color: getColors(context).primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget getAddressEmpty(context) {
    return Padding(
      padding:
          EdgeInsets.only(top: viewPaddingTop(context), left: wXD(18, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Endereço de entrega',
            style: textFamily(
              context,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: getColors(context).onSurface,
            ),
          ),
          SizedBox(height: wXD(10, context)),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                child: Container(
                  width: wXD(120, context),
                  height: wXD(80, context),
                  color: Colors.grey,
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
                      backgroundColor:
                          getColors(context).primary.withOpacity(.3),
                      color: getColors(context).primary.withOpacity(.8),
                    ),
                  ),
                  SizedBox(height: wXD(5, context)),
                  Container(
                    height: wXD(12, context),
                    width: wXD(150, context),
                    child: LinearProgressIndicator(
                      backgroundColor:
                          getColors(context).primary.withOpacity(.3),
                      color: getColors(context).primary.withOpacity(.8),
                    ),
                  ),
                  SizedBox(height: wXD(5, context)),
                  Container(
                    height: wXD(12, context),
                    width: wXD(140, context),
                    child: LinearProgressIndicator(
                      backgroundColor:
                          getColors(context).primary.withOpacity(.3),
                      color: getColors(context).primary.withOpacity(.8),
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  Icons.arrow_forward,
                  size: wXD(20, context),
                  color: getColors(context).primary,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

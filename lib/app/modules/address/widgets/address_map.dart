import 'dart:async';

import 'package:delivery_customer/app/modules/address/address_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/floating_circle_button.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class MapSample extends StatefulWidget {
//   @override
//   State<MapSample> createState() => MapSampleState();
// }

// class MapSampleState extends State<MapSample> {

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       body:
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: Text('To the lake!'),
//         icon: Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

class AddressMap extends StatefulWidget {
  final bool homeRoot;

  AddressMap({Key? key, this.homeRoot = false}) : super(key: key);

  @override
  _AddressMapState createState() => _AddressMapState();
}

class _AddressMapState extends State<AddressMap> {
  final AddressStore addressStore = Modular.get();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (context) {
          return Stack(
            children: [
              DefaultAppBar('Indique o local no mapa'),
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Positioned(
                right: 0,
                bottom: wXD(48, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: wXD(20, context),
                        bottom: wXD(43, context),
                      ),
                      child: FloatingCircleButton(
                        onTap: () {},
                        color: white,
                        size: wXD(52, context),
                        child: Icon(
                          Icons.my_location_outlined,
                          color: black,
                          size: wXD(20, context),
                        ),
                      ),
                    ),
                    SideButton(
                      onTap: () {},
                      height: wXD(52, context),
                      width: wXD(142, context),
                      title: 'Confirmar',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

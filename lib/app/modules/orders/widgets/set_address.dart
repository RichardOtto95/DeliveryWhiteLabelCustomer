// import 'package:delivery_customer/app/modules/address/address_store.dart';
// import 'package:delivery_customer/app/shared/utilities.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';

// import '../../../shared/color_theme.dart';
// import '../../../shared/widgets/default_app_bar.dart';

// class SetAddress extends StatefulWidget {
//   final bool homeRoot;

//   SetAddress({Key? key, this.homeRoot = false}) : super(key: key);

//   @override
//   _SetAddressState createState() => _SetAddressState();
// }

// class _SetAddressState extends State<SetAddress> {
//   final AddressStore addressStore = Modular.get();
//     // late MapShapeSource _dataSource;
//     late MapZoomPanBehavior _zoomPanBehavior;

//   @override
//   void initState() {
//     // _dataSource = MapShapeSource.asset(
//     //   'assets/df.json',
//     //   shapeDataField: 'STATE_NAME',
//     // );
//     _zoomPanBehavior = MapZoomPanBehavior(
//       zoomLevel: 15,
//       enableDoubleTapZooming: true,
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//             future: addressStore.getCurrentPosition(),
//             builder: (context, snapshot) {
//               if(snapshot.hasError){
//                 print(snapshot.error);
//               }

//               if(!snapshot.hasData){
//                 return Center(
//                   child: CircularProgressIndicator(
//                     color:getColors(context).primary,
//                   ),
//                 );
//               }

//               Map<String, dynamic> response = snapshot.data! as Map<String, dynamic>;

//               print('response: $response');

//               if(response['status'] == "FAILED"){
//                 return Container(
//                   height: maxHeight(context),
//                   width: maxWidth(context),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [                    
//                       Text(
//                         "Ative as permissões para continuar!",
//                         style: textFamily(context,),
//                       ),
//                       TextButton(
//                         onPressed: (){
//                           Permission.location.request();
//                         }, 
//                         child: Text(
//                           "Solicitar permissão",
//                           style: textFamily(context,),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }

//               Position userCurrentPosition = response['user-current-position'];
//               // _zoomPanBehavior.focalLatLng = MapLatLng(userCurrentPosition.latitude, userCurrentPosition.longitude);
//               return SfMaps(
//                 layers: [
//                   MapTileLayer(
//                     urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//                     initialFocalLatLng: MapLatLng(userCurrentPosition.latitude, userCurrentPosition.longitude),
//                     initialZoomLevel: 5,
//                     zoomPanBehavior: _zoomPanBehavior,
//                     markerBuilder: (BuildContext context, int index) {
//                       return MapMarker(
//                         latitude: userCurrentPosition.latitude,
//                         longitude: userCurrentPosition.longitude,
//                         child: Icon(                          
//                           Icons.location_on,
//                           color:getColors(context).primary,
//                         ),
//                       );
//                     },
//                     initialMarkersCount: 1,
//                   ),
//                   // MapShapeLayer(
//                   //   source: _dataSource,
//                   //   initialMarkersCount: 1,
//                   //   zoomPanBehavior: _zoomPanBehavior,
//                   //   markerBuilder: (BuildContext context, int index) {
//                   //     return MapMarker(
//                   //       latitude: userCurrentPosition.latitude,
//                   //       longitude: userCurrentPosition.longitude,
//                   //       child: Icon(                          
//                   //         Icons.location_on,
//                   //         color:getColors(context).primary,
//                   //       ),
//                   //     );
//                   //   },
//                   //   loadingBuilder: (BuildContext context){
//                   //     return Center(
//                   //       child: CircularProgressIndicator(
//                   //         color:getColors(context).primary,
//                   //       ),
//                   //     );
//                   //   },
//                   // ),
//                 ],
//               );
//             }
//           ),
//           DefaultAppBar('Adicionar endereço'),
//         ],
//       ),
//     );
//   }
// }

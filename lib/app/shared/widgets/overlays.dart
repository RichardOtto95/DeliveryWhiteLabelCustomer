// import 'package:delivery_customer/app/core/models/address_model.dart';
// import 'package:delivery_customer/app/modules/address/address_store.dart';
// import 'package:delivery_customer/app/modules/main/main_store.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_modular/flutter_modular.dart';

// import '../color_theme.dart';
// import '../utilities.dart';
// import 'address_edition.dart';

// class Overlays {
//   final BuildContext context;

//   Overlays(this.context);

//   final MainStore mainStore = Modular.get();

//   insertAddAddress({
//     bool homeRoot = false,
//     bool editing = false,
//     Address? model,
//   }) {
//     final AddressStore addressStore = Modular.get();
//     double opacity = 0;
//     double bottom = -maxHeight(context);

//     addressStore.editAddressOverlay = OverlayEntry(
//       builder: (overlayContext) {
//         return Positioned(
//           height: maxHeight(context),
//           width: maxWidth(context),
//           child: Observer(
//             builder: (observerContext) {
//               if (addressStore.addressOverlay) {
//                 opacity = .51;
//                 bottom = 0;
//               } else {
//                 bottom = -maxHeight(context);
//                 opacity = 0;
//               }
//               return Material(
//                 color: Colors.transparent,
//                 child: Stack(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         addressStore.addressOverlay = false;
//                         Future.delayed(
//                           Duration(milliseconds: 700),
//                           () {
//                             addressStore.editAddressOverlay!.remove();
//                             addressStore.editAddressOverlay = null;
//                           },
//                         );
//                       },
//                       child: AnimatedOpacity(
//                         duration: Duration(milliseconds: 400),
//                         curve: Curves.ease,
//                         opacity: opacity,
//                         child: Container(
//                           color: black,
//                           height: maxHeight(context),
//                           width: maxWidth(context),
//                         ),
//                       ),
//                     ),
//                     AnimatedPositioned(
//                       duration: Duration(milliseconds: 700),
//                       curve: Curves.ease,
//                       bottom: bottom,
//                       child: AddressEdition(
//                         model: model ?? Address(),
//                         editing: editing,
//                         context: context,
//                         homeRoot: homeRoot,
//                         onBack: () async {
//                           print("onBack");
//                           addressStore.addressOverlay = false;
//                           await Future.delayed(
//                             Duration(milliseconds: 700),
//                             () {
//                               addressStore.editAddressOverlay!.remove();
//                               addressStore.editAddressOverlay = null;
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//     Overlay.of(context)!.insert(addressStore.editAddressOverlay!);
//     addressStore.addressOverlay = true;
//   }
// }

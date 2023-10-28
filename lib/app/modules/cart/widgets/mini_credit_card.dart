// import 'package:delivery_customer/app/core/models/card_model.dart';
// import 'package:delivery_customer/app/shared/color_theme.dart';
// import 'package:delivery_customer/app/shared/utilities.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:flutter_modular/flutter_modular.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../cart_store.dart';

// class MiniCreditCard extends StatelessWidget {
//   final Function()? onTap;
//   final CardModel? cardModel;
//   final CartStore store = Modular.get();

//   MiniCreditCard({
//     Key? key,
//     this.onTap,
//     this.cardModel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Color>? colors;
//     if (cardModel != null) {
//       colors = [Color(cardModel!.colors[0]), Color(cardModel!.colors[1])];
//     }
//     return GestureDetector(
//       onTap: onTap,
//       child: Observer(builder: (context) {
//         return Container(
//           height: wXD(60, context),
//           width: wXD(100, context),
//           margin: EdgeInsets.symmetric(horizontal: wXD(6, context)),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: colors!,
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.all(
//               Radius.circular(18),
//             ),
//             border: store.cardId == cardModel!.cardId
//                 ? Border.all(color:getColors(context).primary, width: wXD(2, context))
//                 : null,
//             boxShadow: [
//               BoxShadow(
//                   offset: Offset(0, 4), color: Color(0x15000000), blurRadius: 4)
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               SizedBox(
//                 width: wXD(30, context),
//                 child: Image.asset(
//                   './assets/images/${cardModel!.brand}.png',
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               Text(
//                 '• • • •  ' + cardModel!.finalNumber,
//                 style: GoogleFonts.rubik(fontSize: 10, color: getColors(context).onBackground),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

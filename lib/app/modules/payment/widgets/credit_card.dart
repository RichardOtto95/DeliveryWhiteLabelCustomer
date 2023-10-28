import 'package:delivery_customer/app/core/models/card_model.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import '../payment_store.dart';

class CreditCard extends StatelessWidget {
  final PaymentStore store = Modular.get();
  final double? width;
  final Function()? onTap;
  final bool addCard;
  final CardModel? cardModel;
  CreditCard({
    Key? key,
    this.width,
    this.onTap,
    this.addCard = false,
    this.cardModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color>? colors;
    if (cardModel != null) {
      colors = [Color(cardModel!.colors[0]), Color(cardModel!.colors[1])];
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: wXD(144, context),
        width: width == null ? wXD(212, context) : width,
        margin: EdgeInsets.symmetric(horizontal: wXD(6, context)),
        padding: EdgeInsets.fromLTRB(
          wXD(18, context),
          wXD(14, context),
          wXD(19, context),
          wXD(20, context),
        ),
        decoration: BoxDecoration(
          // border: Border.all(color: grey),
          gradient: LinearGradient(
            colors: addCard
                ? [
                    Color(store.randomColor1),
                    Color(store.randomColor2),
                  ]
                : colors!,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(9)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 4),
                color: getColors(context).shadow,
                blurRadius: 4)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                addCard == false
                    ? SizedBox(
                        width: wXD(40, context),
                        child: Image.asset(
                          './assets/images/${cardModel!.brand}.png',
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(),
                // Stack(
                //   children: [
                //     SizedBox(width: wXD(40, context), height: wXD(25, context)),
                //     Positioned(
                //       left: 0,
                //       child: Container(
                //         height: wXD(25, context),
                //         width: wXD(25, context),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: Color(0xffEA1D25),
                //         ),
                //       ),
                //     ),
                //     Positioned(
                //       right: 0,
                //       child: Container(
                //         height: wXD(25, context),
                //         width: wXD(25, context),
                //         decoration: BoxDecoration(
                //           shape: BoxShape.circle,
                //           color: Color(0xffF69E1E),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Spacer(),
                Text(
                  addCard == false
                      ? store.getFormatedDueDate(cardModel!.dueDate)
                      : '00/00',
                  style: GoogleFonts.rubik(fontSize: 11, color: white),
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Container(
                  width: wXD(115, context),
                  child: Text(
                    addCard == false
                        ? cardModel!.nameCardHolder
                        : 'Lorem impsum',
                    style: GoogleFonts.inter(fontSize: 13, color: white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
                Text(
                  addCard
                      ? '• • • •  • • • •'
                      : '• • • •  ' + cardModel!.finalNumber,
                  style: GoogleFonts.rubik(fontSize: 11, color: white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

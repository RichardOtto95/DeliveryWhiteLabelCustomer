import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CartAppbar extends StatelessWidget {
  final CartStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Container(
        height: viewPaddingTop(context) + wXD(35, context),
        width: maxWidth(context),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
          color: getColors(context).surface,
          boxShadow: [
            BoxShadow(
                blurRadius: 3,
                offset: Offset(0, 3),
                color: getColors(context).shadow),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: wXD(30, context)),
                alignment: Alignment.centerLeft,
                // child: Transform.rotate(
                //   angle: math.pi * -.5,
                //   child: Icon(
                //     Icons.arrow_back_ios_new_rounded,
                //     size: wXD(25, context),
                //     color:getColors(context).primary,
                //   ),
                // ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Carrinho',
                  style: TextStyle(
                    color: getColors(context).onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => store.cleanItems(),
                  child: Text(
                    'Limpar',
                    style: TextStyle(
                      color: getColors(context).primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

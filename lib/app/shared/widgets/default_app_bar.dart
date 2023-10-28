import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DefaultAppBar extends StatelessWidget {
  final String title;
  final bool noPop;
  final void Function()? onPop;
  DefaultAppBar(this.title, {this.onPop, this.noPop = false});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: maxWidth(context),
            height: viewPaddingTop(context) + wXD(50, context),
            padding: EdgeInsets.only(top: viewPaddingTop(context)),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
              color: getColors(context).surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  color: getColors(context).shadow,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          noPop
              ? Container()
              : Positioned(
                  bottom: 0,
                  left: wXD(5, context),
                  child: InkWell(
                    onTap: () {
                      if (onPop != null) {
                        onPop!();
                      } else {
                        Modular.to.pop();
                      }
                    },
                    child: Container(
                        height: wXD(36, context),
                        width: wXD(48, context),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back,
                          color: getColors(context).onSurface,
                        )),
                  ),
                ),
          Positioned(
            bottom: wXD(9, context),
            child: Text(
              title,
              style: TextStyle(
                color: getColors(context).onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

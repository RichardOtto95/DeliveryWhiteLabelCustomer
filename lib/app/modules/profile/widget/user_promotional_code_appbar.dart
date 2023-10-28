import 'package:delivery_customer/app/modules/home/home_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

class UserPromotionalCodeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeStore store = Modular.get();
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    return Container(
      height: wXD(53, context),
      width: maxWidth(context),
      margin: EdgeInsets.only(top: statusBarHeight),
      // padding: EdgeInsets.only(top: wXD(40, context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
        ),
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: getColors(context).shadow,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Convide os seus amigos',
                    style: TextStyle(
                      color: getColors(context).onBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Positioned(
                  bottom: wXD(6, context),
                  left: wXD(28, context),
                  child: InkWell(
                    onTap: () {
                      Modular.to.pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: SvgPicture.asset(
                        "./assets/svg/arrow_backward.svg",
                        height: wXD(11, context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

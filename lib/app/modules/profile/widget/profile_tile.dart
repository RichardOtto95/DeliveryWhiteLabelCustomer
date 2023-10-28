import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';

import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function() onTap;
  final int? notifications;

  ProfileTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.notifications,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: wXD(60, context),
            width: maxWidth(context),
            margin: EdgeInsets.only(
                left: wXD(30, context), right: wXD(16, context)),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            getColors(context).onBackground.withOpacity(.2)))),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: wXD(24, context),
                  color: getColors(context).onBackground.withOpacity(.5),
                ),
                SizedBox(width: wXD(10, context)),
                Text(
                  title,
                  style: textFamily(context,
                      color: getColors(context).onBackground, fontSize: 18),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_sharp,
                  size: wXD(24, context),
                  color: getColors(context).onBackground,
                ),
              ],
            ),
          ),
          notifications != null && notifications! > 0
              ? Positioned(
                  top: 10,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.only(bottom: wXD(2, context)),
                    height: wXD(notifications! > 9 ? 18 : 15, context),
                    width: wXD(notifications! > 9 ? 18 : 15, context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: getColors(context).primary,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      notifications! > 9 ? "+9" : notifications.toString(),
                      style: textFamily(
                        context,
                        color: white,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

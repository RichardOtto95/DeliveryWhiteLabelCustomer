import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final void Function() onTap;
  SettingsTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: wXD(60, context),
        width: maxWidth(context),
        margin:
            EdgeInsets.only(left: wXD(32, context), right: wXD(16, context)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: getColors(context).onBackground.withOpacity(.2)))),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
              style: textFamily(context,
                  color: getColors(context).onBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
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
    );
  }
}

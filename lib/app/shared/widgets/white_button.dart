import 'package:flutter/material.dart';

import '../utilities.dart';

class WhiteButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onTap;
  WhiteButton({required this.icon, required this.text, required this.onTap});
  @override
  Widget build(context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(3)),
      child: Container(
        height: wXD(47, context),
        width: wXD(116, context),
        decoration: BoxDecoration(
          color: getColors(context).surface,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border:
              Border.all(color: getColors(context).onSurface.withOpacity(.33)),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(0, 3),
              color: Color(0x10000000),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: getColors(context).onBackground,
              size: wXD(22, context),
            ),
            Text(
              text,
              style: textFamily(
                context,
                color: getColors(context).onBackground,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

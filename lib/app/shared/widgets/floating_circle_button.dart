import 'package:flutter/material.dart';

import '../utilities.dart';

class FloatingCircleButton extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final Color? iconColor;
  final Color? color;
  final double? size;
  final double iconSize;
  final Widget? child;
  const FloatingCircleButton({
    Key? key,
    required this.onTap,
    this.color,
    this.size,
    this.child,
    this.iconColor,
    this.icon = Icons.search_rounded,
    this.iconSize = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size ?? wXD(68, context),
        width: size ?? wXD(68, context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.black,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 3),
              color: getColors(context).shadow,
            )
          ],
        ),
        alignment: Alignment.center,
        child: child ??
            Icon(
              icon,
              size: wXD(iconSize, context),
              color: iconColor,
            ),
      ),
    );
  }
}

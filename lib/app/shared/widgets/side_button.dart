import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final bool isRight;
  final void Function() onTap;
  final String title;
  final Color? color;
  final Color? fontColor;

  const SideButton({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
    this.color,
    this.isRight = true,
    this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("fontSize: $fontSize");
    return Align(
      // alignment: isWhite ? Alignment.centerLeft : Alignment.centerRight,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? wXD(81, context),
          height: height ?? wXD(44, context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
                // left: Radius.circular(isWhite
                //     ? isRight
                //         ? 50
                //         : 0
                //     : 50),
                // right: Radius.circular(isWhite
                //     ? isRight
                //         ? 0
                //         : 50
                //     : 0),
                ),
            border: Border.all(
              color: color ?? getColors(context).primary,
            ),
            color: color ?? getColors(context).primary,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: isWhite ? Color(0x80000000) : Color(0x30000000),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: child == null
              ? Text(
                  title,
                  style: textFamily(
                    context,
                    color: fontColor != null
                        ? fontColor
                        : !isWhite
                            ? getColors(context).onPrimary
                            : getColors(context).primary,
                    fontSize: fontSize ?? 18,
                  ),
                )
              : child,
        ),
      ),
    );
  }
}

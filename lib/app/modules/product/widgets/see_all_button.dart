import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final String title;
  final void Function() onTap;
  const SeeAllButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: wXD(44, context),
          width: wXD(349, context),
          padding:
              EdgeInsets.only(left: wXD(12, context), right: wXD(19, context)),
          decoration: BoxDecoration(
            border: Border.all(color: grey.withOpacity(.4)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textFamily(
                  context,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: getColors(context).primary,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: getColors(context).primary,
                size: wXD(20, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

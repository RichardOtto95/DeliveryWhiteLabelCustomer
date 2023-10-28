import 'dart:ui';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class ConfirmPopup extends StatelessWidget {
  final String text;
  final Future Function() onConfirm;
  final void Function() onCancel;
  final double? height;
  const ConfirmPopup({
    Key? key,
    required this.text,
    required this.onConfirm,
    required this.onCancel,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: onCancel,
              child: Container(
                height: maxHeight(context),
                width: maxWidth(context),
                color: getColors(context).shadow,
                alignment: Alignment.center,
              ),
            ),
            Container(
              height: height ?? wXD(145, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: BoxDecoration(
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: getColors(context).shadow,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: textFamily(context, fontSize: 17),
                  ),
                  Spacer(),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: loadCircular
                            ? [
                                Align(
                                  child: CircularProgressIndicator(
                                    color: getColors(context).primary,
                                  ),
                                )
                              ]
                            : [
                                BlackButton(text: 'Não', onTap: onCancel),
                                SizedBox(width: wXD(14, context)),
                                BlackButton(
                                  text: 'Sim',
                                  onTap: () async {
                                    setState(() {
                                      loadCircular = true;
                                    });
                                    await onConfirm();
                                    setState(() {
                                      loadCircular = false;
                                    });
                                  },
                                ),
                              ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlackButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const BlackButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(47, context),
        width: wXD(82, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
                blurRadius: 8, offset: Offset(0, 3), color: getColors(context).shadow)
          ],
          color: getColors(context).surface,
          border: Border.all(
            color: brightness == Brightness.light ? black : white,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textFamily(
            context,
            color: getColors(context).primary,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class RedirectPopup extends StatelessWidget {
  final String text;
  final void Function() onConfirm, onCancel;
  final double? height;
  const RedirectPopup({
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
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: black.withOpacity(.6),
          alignment: Alignment.center,
          child: Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
              topRight: Radius.circular(80),
            ),
            child: Container(
              height: height ?? wXD(136, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
                boxShadow: [
                  BoxShadow(blurRadius: 18, color: getColors(context).shadow)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: textFamily(context, fontSize: 17, color: getColors(context).surface),
                  ),
                  Spacer(),
                  StatefulBuilder(builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: loadCircular
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.end,
                      children: loadCircular
                          ? [
                              CircularProgressIndicator(
                                color: Colors.orange,
                              )
                            ]
                          : [
                              BlackButton(text: 'Não', onTap: onCancel),
                              SizedBox(width: wXD(14, context)),
                              BlackButton(
                                  text: 'Sim',
                                  onTap: () {
                                    setState(() {
                                      loadCircular = true;
                                      onConfirm();
                                    });
                                  }),
                            ],
                    );
                  })
                ],
              ),
            ),
          ),
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
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: black,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: textFamily(context,
                color: getColors(context).primary, fontSize: 17),
          )),
    );
  }
}

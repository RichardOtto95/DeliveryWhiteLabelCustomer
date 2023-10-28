import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Option extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool qtd;

  Option({
    Key? key,
    required this.title,
    required this.options,
    this.qtd = false,
  }) : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {
  String optionSelected = '';

  @override
  void initState() {
    optionSelected = widget.options.first;
    super.initState();
  }

  @override
  Widget build(context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: wXD(17, context)),
        padding: EdgeInsets.symmetric(horizontal: wXD(21, context)),
        height: wXD(41, context),
        width: wXD(316, context),
        decoration: BoxDecoration(
            color: veryLightOrange,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          children: [
            Text(
              '${widget.title}: ',
              style: textFamily(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: grey,
              ),
            ),
            Text(
              '${widget.options.first}',
              style: textFamily(
                context,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: black,
              ),
            ),
            widget.qtd ? Spacer() : Container(),
            widget.qtd
                ? Text(
                    '(${widget.options.last} disponíveis)',
                    style: textFamily(
                      context,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: grey.withOpacity(.5),
                    ),
                  )
                : Container(),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: wXD(2, context)),
              child: Transform.rotate(
                angle: math.pi * 1.5,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: getColors(context).primary,
                  size: wXD(22, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

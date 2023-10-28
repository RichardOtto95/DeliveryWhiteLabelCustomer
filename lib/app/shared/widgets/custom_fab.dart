import 'package:flutter/material.dart';

class CustomFloatActionButton extends StatelessWidget {
  const CustomFloatActionButton(
      {Key? key, required this.titleButton, required this.onPressedButton})
      : super(key: key);

  final String titleButton;
  final onPressedButton;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(1.2,1),
      child: Container(
          width: 142,
          height: 52,
          child: RawMaterialButton(
            fillColor: Colors.black,
            child: Text(titleButton,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[900])),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            onPressed: onPressedButton,
          )),
    );
  }
}

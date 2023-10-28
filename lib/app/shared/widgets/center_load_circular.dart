import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class CenterLoadCircular extends StatelessWidget {
  final double? top;
  const CenterLoadCircular({Key? key, this.top}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top ?? 0),
      height: maxHeight(context),
      alignment: top != null ? Alignment.topCenter : Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(getColors(context).primary),
      ),
    );
  }
}

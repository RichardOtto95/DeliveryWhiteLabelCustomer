import 'dart:ui';

import 'package:flutter/material.dart';

import '../color_theme.dart';
import '../utilities.dart';

class LoadCircularOverlay extends StatelessWidget {
  const LoadCircularOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          color: getColors(context).shadow,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(getColors(context).primary),
          ),
        ),
      ),
    );
  }
}

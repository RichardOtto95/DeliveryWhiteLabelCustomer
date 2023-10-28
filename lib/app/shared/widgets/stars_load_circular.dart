import 'package:flutter/material.dart';

import '../color_theme.dart';
import '../utilities.dart';

class StarsLoadCircular extends StatefulWidget {
  final double? size;
  const StarsLoadCircular({Key? key, this.size}) : super(key: key);

  @override
  _StarsLoadCircularState createState() => _StarsLoadCircularState();
}

class _StarsLoadCircularState extends State<StarsLoadCircular>
    with SingleTickerProviderStateMixin {
  // late AnimationController animationController;
  @override
  void initState() {
    super.initState();
    // animationController = new AnimationController(
    //   vsync: this,
    //   duration: new Duration(milliseconds: 5000),
    // );
    // animationController.forward();
    // animationController.addListener(() {
    //   // setState(() {
    //   if (animationController.status == AnimationStatus.completed) {
    //     animationController.repeat();
    //   }
    //   // });
    // });
  }

  @override
  void dispose() {
    // animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star_outline_rounded,
          color: getColors(context).primary,
          size: widget.size ?? wXD(25, context),
        ),
      ),
    );
  }
}

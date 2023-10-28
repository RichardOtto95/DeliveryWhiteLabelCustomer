import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../utilities.dart';

class TextScore extends StatelessWidget {
 final AdditionalModel model;

  TextScore({Key? key, required this.model}) : super(key: key);
  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: wXD(15, context),
              bottom: wXD(15, context),
            ),
            child: Text(
              model.title,
              style: textFamily(context,
                fontSize: model.fontSize.toDouble(),
                color: getColors(context).onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
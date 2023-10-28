import 'package:flutter/material.dart';
import '../../core/models/additional_model.dart';
import '../utilities.dart';

class TextAreaConstructor extends StatelessWidget {
  final AdditionalModel model;
  final String? responseText;


  const TextAreaConstructor({Key? key, required this.model, required this.responseText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getText(model.title, model.mandatory!),
          style: textFamily(context,
            fontSize: 15,
            color: getColors(context).onBackground,
          ),
        ),
        SizedBox(height: wXD(5, context),),
        Container(
          width: maxWidth(context),
          margin: EdgeInsets.symmetric(
              horizontal: wXD(15, context)),
          padding: EdgeInsets.symmetric(
              horizontal: wXD(8, context),
              vertical: wXD(5, context)),
          height: wXD(200, context),
          decoration: BoxDecoration(
            border:
                Border.all(color: getColors(context).primary),
            borderRadius:
                BorderRadius.all(Radius.circular(12)),
          ),
          child: TextFormField(
            enabled: false,
            maxLines: 5,
            decoration: InputDecoration.collapsed(
                hintText: model.hint),
            initialValue: responseText,
          ),
        ), 
      ],
    );
  }

  getText(String title, bool mandatory){
    String _title = mandatory ? title + "*" : title;
    return _title;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../../modules/main/main_store.dart';
import '../utilities.dart';

class TextFieldConstructor extends StatelessWidget {
  final AdditionalModel additionalModel;
  final String? responseText;

  TextFieldConstructor({
    Key? key, 
    required this.additionalModel, 
    required this.responseText,
  }) : super(key: key);

  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: mainStore.getColumnAlignment(additionalModel.alignment),
        children: [
          Text(
            getText(additionalModel.title, additionalModel.mandatory!),
            style: textFamily(context,
              fontSize: 15,
              color: getColors(context).onBackground,
            ),
          ),
          SizedBox(height: wXD(5, context),),
          Container(
            child: Container(
              width: additionalModel.short! ? maxWidth(context) /2 : maxWidth(context),
              padding: EdgeInsets.symmetric(
                horizontal: wXD(8, context),
                vertical: wXD(5, context),
              ),
              decoration: BoxDecoration(
                border:
                  Border.all(color: getColors(context).primary),
                borderRadius:
                  BorderRadius.all(Radius.circular(12)),
              ),
              child: TextFormField(
                initialValue: responseText,
                maxLines: 1,
                decoration: InputDecoration.collapsed(hintText: additionalModel.hint),
                enabled: false,
              ),
            ),
          ), 
        ],
      ),
    );
  }

  getText(String title, bool mandatory){
    String _title = mandatory ? title + "*" : title;
    return _title;
  }
}
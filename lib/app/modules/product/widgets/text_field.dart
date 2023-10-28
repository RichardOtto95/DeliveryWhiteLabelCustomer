import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/utilities.dart';
import '../product_store.dart';

class TextFieldScore extends StatelessWidget {
  final AdditionalModel model;
  final ProductStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  TextFieldScore({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if(!store.product.containsKey(model.id)){
    //   store.product.putIfAbsent(model.id, () => {
    //     "response_text": "",
    //     "additional_type": "text",
    //   });
    // } 
    return Container(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: wXD(15, context),
            ),
            child: Text(
              getText(model.title, model.mandatory!),
              style: textFamily(context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          SizedBox(height: wXD(5, context),),
          Container(
            child: Container(
              width: model.short! ? maxWidth(context) /2 : maxWidth(context),
              padding: EdgeInsets.symmetric(
                  horizontal: wXD(8, context),
                  vertical: wXD(5, context)),
              // height: wXD(200, context),
              decoration: BoxDecoration(
                border:
                    Border.all(color: getColors(context).primary),
                borderRadius:
                    BorderRadius.all(Radius.circular(12)),
              ),
              child: TextFormField(
                maxLines: 1,
                decoration: InputDecoration.collapsed(hintText: model.hint),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value){
                  if(value == null || value == "" && model.mandatory!){
                    return "Preencha corretamente";
                  } else {
                    return null;
                  }
                },
                onChanged: (String value){
                  // if(!store.product.containsKey(model.id)){
                  //   store.product.putIfAbsent(model.id, () => {
                  //     "response_text": value,
                  //     "additional_type": "text",
                  //   });
                  // } else {
                    store.product.update(model.id, (valueMap) => {
                      "response_text": value,
                      "additional_type": "text",
                    });
                  // }
                },
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
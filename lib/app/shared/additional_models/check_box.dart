import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../../modules/main/main_store.dart';
import '../utilities.dart';

class CheckBoxArrayConstructor extends StatelessWidget {
  final MainStore store = Modular.get();
  final AdditionalModel model;
  final Map responseMap;
  final String sellerId;

  CheckBoxArrayConstructor({
    Key? key, 
    required this.model,
    required this.sellerId,
    required this.responseMap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('responseMap : $responseMap');
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getCheckboxList(model.id, sellerId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }
          List<Map<String, dynamic>> checkboxArray = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [       
              Text(
                model.title,
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),       
              Column(
                children: List.generate(
                  checkboxArray.length, 
                  (i) {
                    Map<String, dynamic> checkboxMap = checkboxArray[i];
                    // print('checkboxMap[id] : $checkboxMap');
                    // print('responseMap[checkboxMap[id]] : ${responseMap[checkboxMap['id']]}');
                    return Row(
                      children: [
                        Checkbox(
                          activeColor: colors.primary,
                          value: responseMap[checkboxMap['id']] != null ? responseMap[checkboxMap['id']] : false,
                          onChanged: (bool? value){},
                        ),
                        Expanded(child: Text(checkboxMap['label'])),
                        SizedBox(width: wXD(15, context),),
                        Container(
                          width: wXD(100, context),
                          child: Text("R\$ ${formatedCurrency(checkboxMap['value'])}"),
                          alignment: Alignment.centerLeft,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
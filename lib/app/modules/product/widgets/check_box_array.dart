import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/utilities.dart';
import '../product_store.dart';

class CheckBoxArray extends StatefulWidget {
  final AdditionalModel model;
  final String sellerId;

  CheckBoxArray({
    Key? key, 
    required this.model,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<CheckBoxArray> createState() => _CheckBoxArrayState();
}

class _CheckBoxArrayState extends State<CheckBoxArray> {
  final ProductStore store = Modular.get();
  Map checkedMap = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        // right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getCheckboxList(widget.model.id, widget.sellerId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }

          List<Map<String, dynamic>> checkboxArray = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [       
              Text(
                widget.model.title,
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
                    checkedMap.putIfAbsent(checkboxMap['id'], () => {
                      "response": false,
                      "value": checkboxMap['value'],
                    });

                    return Row(
                      children: [
                        Checkbox(
                          activeColor: colors.primary,
                          value: checkedMap[checkboxMap['id']]['response'],
                          onChanged: (bool? value){
                            setState(() {
                              checkedMap.update(checkboxMap['id'], (valueMap) => {
                                "response": value,
                                "value": checkboxMap['value'],
                              });
                              // if(store.product.containsKey(widget.model.id)){
                                store.product.update(widget.model.id, (previousValue) => {
                                  "additional_type": "check-box",                                  
                                  "checked_map": checkedMap,
                                });
                              // } else {
                              //   store.product.putIfAbsent(widget.model.id, () => {
                              //     "additional_type": "check-box",                                  
                              //     "checked_map": checkedMap,
                              //   });
                              // }
                            });
                          },
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
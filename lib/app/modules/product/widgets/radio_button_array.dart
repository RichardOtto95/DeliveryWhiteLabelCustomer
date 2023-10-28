import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/utilities.dart';
import '../product_store.dart';

class RadioButtonArray extends StatefulWidget {
  final AdditionalModel additionalModel;
  final String sellerId;

  RadioButtonArray({
    Key? key, 
    required this.additionalModel,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<RadioButtonArray> createState() => _RadioButtonArrayState();
}

class _RadioButtonArrayState extends State<RadioButtonArray> {
  final ProductStore store = Modular.get();
  int groupValue = 0;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getRadiobuttonList(widget.additionalModel.id, widget.sellerId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }
          List<Map<String, dynamic>> radiobuttonArray = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.additionalModel.title,
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Column(
                children: List.generate(
                  radiobuttonArray.length,
                  (i) {
                    Map<String, dynamic> radiobuttonMap = radiobuttonArray[i];
                    // if(i == 0){
                    //   store.product.putIfAbsent(widget.additionalModel.id, () => {
                    //     "additional_type": "radio-button",
                    //     "response_index": groupValue,
                    //     "response_label": radiobuttonMap['label'],
                    //     "response_value": radiobuttonMap['value'],
                    //   });
                    // }
                    return Row(
                      children: [
                        Radio(
                          activeColor: colors.primary,
                          value: i,
                          groupValue: groupValue,
                          onChanged: (int? value) {
                            setState(() {
                              groupValue = value!;
                              store.product.update(widget.additionalModel.id, (valueMap) => {
                                "additional_type": "radio-button",
                                "response_index": groupValue,
                                "response_label": radiobuttonMap['label'],
                                "response_value": radiobuttonMap['value'],
                              });
                            });
                          },
                        ),
                        Expanded(
                          child: Text(radiobuttonMap['label']),
                        ),
                        SizedBox(width: wXD(15, context),),
                        Container(
                          width: wXD(100, context),
                          child: Text('R\$ ${formatedCurrency(radiobuttonMap['value'])}'),
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
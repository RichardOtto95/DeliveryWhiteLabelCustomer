import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../core/models/additional_model.dart';
import '../../../shared/utilities.dart';
import '../product_store.dart';

class DropdownArray extends StatefulWidget {
  final AdditionalModel model;
  final String sellerId;

  DropdownArray({
    Key? key, 
    required this.model,
    required this.sellerId,
  }) : super(key: key);

  @override
  State<DropdownArray> createState() => _DropdownArrayState();
}

class _DropdownArrayState extends State<DropdownArray> {
  final ProductStore store = Modular.get();
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: wXD(15, context),
      ),
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [    
            Text(
              widget.model.title,
              style: textFamily(context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),             
          FutureBuilder<List<Map<String, dynamic>>>(
            future: store.getDropdownList(widget.model.id, widget.sellerId),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }
              List<Map<String, dynamic>> dropdownArray = snapshot.data!;
              if(dropdownValue == null){
                dropdownValue = dropdownArray[0]['label'];
              }
              
              // if(!store.product.containsKey(widget.model.id)){
              //   store.product.putIfAbsent(widget.model.id, () => {
              //     "additional_type": "combo-box",
              //     "response_label": dropdownArray[0]['label'],
              //     "response_index": dropdownArray[0]['index'],
              //     "response_value": dropdownArray[0]['value'],
              //   });
              // }

              return Container(
                padding: EdgeInsets.only(
                  left: wXD(18, context),
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: colors.primary,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      for (var i = 0; i < dropdownArray.length; i++) {
                        Map<String, dynamic> dropdownMap = dropdownArray[i];
                        if(dropdownValue == dropdownMap['label']){
                          store.product.update(widget.model.id, (valueMap) => {
                            "additional_type": "combo-box",
                            "response_label": dropdownMap['label'],
                            "response_index": dropdownMap['index'],
                            "response_value": dropdownMap['value'],
                          });

                          break;
                        }
                      }
                    });
                  },
                  items: dropdownArray.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                    return DropdownMenuItem<String>(
                      value: value['label'],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(value['label']),
                          Text("R\$ ${formatedCurrency(value['value'])}"),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
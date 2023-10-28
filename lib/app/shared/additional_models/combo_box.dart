import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../../modules/main/main_store.dart';
import '../utilities.dart';

class DropdownArrayConstructor extends StatelessWidget {
  final AdditionalModel model;
  final String sellerId;
  final MainStore store = Modular.get();
  final String responseLabel;


  DropdownArrayConstructor({
    Key? key, 
    required this.model,
    required this.sellerId,
    required this.responseLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: wXD(15, context),
        // left: wXD(18, context),
      ),
      // height: 50,
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [    
            Text(
              model.title,
              style: textFamily(context,
                fontSize: 15,
                color: getColors(context).onBackground,
              ),
            ),             
          FutureBuilder<List<Map<String, dynamic>>>(
            future: store.getDropdownList(model.id, sellerId),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }
              List<Map<String, dynamic>> dropdownArray = snapshot.data!;

              return Container(
                margin: EdgeInsets.only(
                  left: wXD(18, context),
                ),
                child: DropdownButton<String>(
                  value: responseLabel,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: colors.primary,
                  ),
                  onChanged: (String? newValue) {},
                  items: dropdownArray.map<DropdownMenuItem<String>>((Map<String, dynamic> value) {
                    return DropdownMenuItem<String>(
                      enabled: false,
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
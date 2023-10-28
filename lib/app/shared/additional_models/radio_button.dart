import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';
import '../utilities.dart';

class RadioButtonConstructor extends StatelessWidget {
  final AdditionalModel additionalModel;
  final String sellerId;
  final String responseLabel;

  RadioButtonConstructor({
    Key? key, 
    required this.additionalModel,
    required this.sellerId,
    required this.responseLabel,
  }) : super(key: key);
  
  final MainStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: wXD(15, context),
        top: wXD(15, context),
        bottom: wXD(5, context),
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: store.getRadiobuttonList(additionalModel.id, sellerId),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Container();
          }
          List<Map<String, dynamic>> radiobuttonArray = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                additionalModel.title,
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
                    return Row(
                      children: [
                        Radio(
                          activeColor: colors.primary,
                          value: radiobuttonMap['label'],
                          groupValue: responseLabel,
                          onChanged: (dynamic value) {},
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
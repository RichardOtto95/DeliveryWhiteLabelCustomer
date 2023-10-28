import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/models/additional_model.dart';

class IncrementFieldConstructor extends StatelessWidget {
  final AdditionalModel model;
  final num? responseCount;
  final num? responseValue;

  IncrementFieldConstructor({Key? key, required this.model, required this.responseCount, required this.responseValue}) : super(key: key);

  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: wXD(15, context)),
      child: Column(
        crossAxisAlignment: mainStore.getColumnAlignment(model.alignment),
        children: [
          Text(
            model.title,
            style: textFamily(context,
              fontSize: 15,
              color: getColors(context).onBackground,
            ),
          ),
          Row(
            mainAxisAlignment: mainStore.getRowAlignment(model.alignment),
            children: [                 
              Container(
                height: wXD(25, context),
                width: wXD(88, context),
                margin: EdgeInsets.only(top: wXD(4, context)),
                padding:
                    EdgeInsets.symmetric(horizontal: wXD(4, context)),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: getColors(context).onSurface.withOpacity(.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.remove,
                        size: wXD(20, context),
                        color: getColors(context).primary.withOpacity(.4)
                      ),
                    ),
                    Container(
                      width: wXD(32, context),
                      height: wXD(25, context),
                      decoration: BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(
                            color: getColors(context)
                                .onSurface
                                .withOpacity(.3),
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        responseCount != null ? responseCount.toString() : "0",
                        style: textFamily(context,
                            color: getColors(context).primary),
                      ),
                    ),
                    InkWell(
                      onTap: (){},
                      child: Icon(
                        Icons.add,
                        size: wXD(20, context),
                        color: getColors(context).primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: wXD(10, context),
              ),
              Text(
                "R\$ ${formatedCurrency(responseValue)}",
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
            ],
          ),
          SizedBox(height: wXD(10, context),),              
        ],
      ),
    );
  }
}
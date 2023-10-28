import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/models/additional_model.dart';
import '../../../shared/utilities.dart';
import '../product_store.dart';

class IncrementField extends StatefulWidget {
  final AdditionalModel model;
  const IncrementField({Key? key, required this.model}) : super(key: key);

  @override
  State<IncrementField> createState() => _IncrementFieldState();
}

class _IncrementFieldState extends State<IncrementField> {
  final ProductStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  num count = 0;
  num incrementValue = 0;

  @override
  void initState(){
    if(widget.model.incrementValue != null){
      incrementValue = widget.model.incrementValue!;
    }
    count = widget.model.incrementMinimum!;
    // print('widget.model: ${widget.model.toJson()}');
    // store.product.putIfAbsent(widget.model.id, () => {
    //   "additional_type": "increment",
    //   "response_count": count,
    //   "response_value": incrementValue * count,
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, refresh) {
        return Container(
          margin: EdgeInsets.only(top: wXD(15, context)),
          child: Column(
            crossAxisAlignment: mainStore.getColumnAlignment(widget.model.alignment),
            children: [
              Text(
                widget.model.title,
                style: textFamily(context,
                  fontSize: 15,
                  color: getColors(context).onBackground,
                ),
              ),
              Row(
                mainAxisAlignment: mainStore.getRowAlignment(widget.model.alignment),
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
                      // borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if(count > widget.model.incrementMinimum!){
                              setState(() {
                                count --;
                                store.product.update(widget.model.id, (valueMap) => {
                                  "additional_type": "increment",
                                  "response_count": count,
                                  "response_value": incrementValue * count,
                                });                                
                              });
                            }
                          },
                          child: Icon(
                            Icons.remove,
                            size: wXD(20, context),
                            color: count > widget.model.incrementMinimum! ?
                            getColors(context).primary :
                            getColors(context).primary.withOpacity(.4),
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
                            count.toString(),
                            style: textFamily(context,
                                color: getColors(context).primary),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            if(widget.model.incrementMaximum == null || count < widget.model.incrementMaximum!){
                              setState(() {
                                count ++;
                                store.product.update(widget.model.id, (valueMap) => {
                                  "additional_type": "increment",
                                  "response_count": count,
                                  "response_value": incrementValue * count,
                                });                                
                              });
                            }
                          },
                          child: Icon(
                            Icons.add,
                            size: wXD(20, context),
                            color: widget.model.incrementMaximum == null || (count < widget.model.incrementMaximum!) ?
                            getColors(context).primary : 
                            getColors(context).primary.withOpacity(.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: wXD(10, context),
                  ),
                  Text(
                    "R\$ ${formatedCurrency(incrementValue * count)}",
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
    );
  }
}
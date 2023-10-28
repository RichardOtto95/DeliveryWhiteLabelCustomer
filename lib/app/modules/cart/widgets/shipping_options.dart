import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cart_store.dart';

class ShippingOptions extends StatelessWidget {
  ShippingOptions({Key? key}) : super(key: key);
  final CartStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    List shippingOptions = [
      {
        'type': 'express',
        'shipping_option': 'Entrega expressa',
        'duration': Duration(hours: 2),
        'price': 'Grátis',
      },
      // {
      //   'type': 'mail',
      //   'shipping_option': 'PAC Correios',
      //   'duration': Duration(days: 8),
      //   'price': 48,
      // },
    ];
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        padding: EdgeInsets.fromLTRB(
          wXD(18, context),
          wXD(18, context),
          wXD(18, context),
          wXD(5, context),
        ),
        child: Column(
          children: [
            ShippingOption(
              type: shippingOptions[0]['type'],
              shippingOption: shippingOptions[0]['shipping_option'],
              shippingTime: shippingOptions[0]['duration'],
              price: shippingOptions[0]['price'],
              val: store.val,
              onChanged: (int? i) {
                // store.deliveryType = 'express';
                setState(() {
                  store.val = i!;
                });
              },
            ),
            // ShippingOption(
            //   type: shippingOptions[1]['type'],
            //   shippingOption: shippingOptions[1]['shipping_option'],
            //   shippingTime: shippingOptions[1]['duration'],
            //   price: shippingOptions[1]['price'],
            //   val: store.val,
            //   onChanged: (int? i) {
            //     store.deliveryType = 'mail';

            //     setState(() {
            //       store.val = i!;
            //     });
            //   },
            // ),
          ],
        ),
      );
    });
  }
}

class ShippingOption extends StatelessWidget {
  final String shippingOption, type;
  final Duration shippingTime;
  final dynamic price;
  final int val;
  final void Function(int?) onChanged;
  const ShippingOption({
    Key? key,
    required this.shippingOption,
    required this.shippingTime,
    required this.price,
    required this.type,
    required this.val,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String period = '';
    if (shippingTime.inDays > 0) {
      period = '${shippingTime.inDays.toString()} dias';
    } else {
      period = '${shippingTime.inHours.toString()}h';
    }
    return Container(
      margin: EdgeInsets.only(bottom: wXD(13, context)),
      width: maxWidth(context) - wXD(36, context),
      child: Row(
        children: [
          Radio(
            value: type == 'express' ? 1 : 2,
            groupValue: val,
            onChanged: (int? value) {
              onChanged(value!);
            },
            activeColor: Colors.black,
          ),
          Text(
            '$shippingOption - em até $period',
            style: textFamily(context,
                fontSize: 13, color: getColors(context).onBackground),
          ),
          Spacer(),
          Text(
            price == 'Grátis' ? 'Grátis' : 'R\$${formatedCurrency(price)}',
            style: textFamily(context,
                fontSize: 13, color: getColors(context).primary),
          ),
        ],
      ),
    );
  }
}

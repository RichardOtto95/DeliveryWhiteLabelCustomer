import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../cart_store.dart';

class PromotionalCode extends StatelessWidget {
  final Function setState;
  final FocusNode focusNode;
  PromotionalCode({Key? key, required this.setState, required this.focusNode})
      : super(key: key);
  final CartStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: wXD(12, context)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onBackground.withOpacity(.3)))),
      width: maxWidth(context),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: wXD(12, context)),
            padding: EdgeInsets.fromLTRB(
              wXD(15, context),
              wXD(0, context),
              wXD(15, context),
              wXD(3, context),
            ),
            width: wXD(276, context),
            height: wXD(52, context),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              // borderRadius: BorderRadius.all(Radius.circular(18)),
            ),
            alignment: Alignment.center,
            child: TextField(
              focusNode: focusNode,
              controller: store.textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: 'Adicione o código promocional',
                hintStyle: textFamily(context,
                    color: getColors(context).onBackground.withOpacity(.55)),
              ),
              onChanged: (value) {
                print('onChanged value: $value');

                store.promotionalCode = value;
                print('onChanged promotionalCode: ${store.promotionalCode}');
              },
            ),
          ),
          Spacer(),
          SideButton(
            // isRight: true,
            // isWhite: true,
            color: Colors.black,
            onTap: () async {
              print('sideButon onTap: ${store.promotionalCode}');
              print('onPressed');
              await store.findCoupon(context);
              setState();
            },
            title: 'Usar',
          ),
        ],
      ),
    );
  }
}

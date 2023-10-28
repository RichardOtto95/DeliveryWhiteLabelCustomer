import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/cart/cart_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class OrderNotPaid extends StatefulWidget {
  final DocumentSnapshot orderDoc;

  const OrderNotPaid({
    Key? key,
    required this.orderDoc,
  }) : super(key: key);
  @override
  _OrderNotPaidState createState() => _OrderNotPaidState();
}

class _OrderNotPaidState extends State<OrderNotPaid> {
  final CartStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    print('initstate OrderNotPaid');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.loadOverlay != null && store.loadOverlay!.mounted) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  wXD(19, context),
                  wXD(40, context),
                  wXD(10, context),
                  wXD(32, context),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Para realizar outro pedido, pague o débito',
                      style: textFamily(
                        context,
                        fontSize: 14,
                        color: Color(0xff241332),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                brightness == Brightness.light
                    ? "./assets/images/logo.png"
                    : "./assets/images/logo_dark.png",
                width: wXD(193, context),
                height: wXD(173, context),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  wXD(19, context),
                  wXD(40, context),
                  wXD(15, context),
                  wXD(32, context),
                ),
                child: Column(
                  children: [
                    Text(
                      'É simples, basta',
                      style: textFamily(
                        context,
                        fontSize: 15,
                        color: darkGrey,
                      ),
                    ),
                    Text(
                      'Fazer o pix no valor de: R\$ ' +
                          formatedCurrency(
                              widget.orderDoc['price_total_with_discount']) +
                          ", referente ao pedido de código: ${widget.orderDoc['code']}" +
                          ", chave pix: cnpj.",
                      style: textFamily(
                        context,
                        fontSize: 15,
                        color: darkGrey,
                      ),
                    ),
                    Text(
                      "Agora é só esperar o pagamento ser aprovado.",
                      style: textFamily(
                        context,
                        fontSize: 15,
                        color: darkGrey,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                                ClipboardData(text: '29.412.420/0001-67'))
                            .then((value) {
                          showToast('Chave copiada');
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Container(
                          //       color: darkGrey,
                          //       child: Text(
                          //         'Chave copiada',
                          //         style: textFamily(context,
                          //           fontSize: 20,
                          //           color: primary,
                          //         ),
                          //       ),
                          //     ),

                          //   ),
                          // );
                        });
                      },
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '29.412.420/0001-67',
                            style: textFamily(
                              context,
                              fontSize: 20,
                              color: darkGrey,
                            ),
                          ),
                          Text(
                            'Pressione aqui para copiar',
                            style: textFamily(
                              context,
                              fontSize: 10,
                              color: primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:delivery_customer/app/core/models/card_model.dart';
import 'package:delivery_customer/app/modules/payment/payment_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'credit_card.dart';

class CardDetails extends StatefulWidget {
  final Map args;
  CardDetails({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final PaymentStore store = Modular.get();
  late bool main;
  late CardModel cardModel;
  late bool itsUnic;

  @override
  void initState() {
    cardModel = widget.args['card-model'];
    itsUnic = widget.args['its-unic'];
    main = cardModel.main;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.confirmDeleteOverlay != null &&
            store.confirmDeleteOverlay!.mounted) {
          store.confirmDeleteOverlay!.remove();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              // height: maxHeight(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: maxWidth(context),
                    padding: EdgeInsets.only(
                      top: viewPaddingTop(context) + wXD(60, context),
                      bottom: wXD(30, context),
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(60)),
                      color: getColors(context).onBackground,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CreditCard(
                          width: wXD(257, context),
                          cardModel: cardModel,
                        ),
                        SizedBox(height: wXD(33, context)),
                        Row(
                          children: [
                            SizedBox(width: wXD(41, context)),
                            Column(
                              children: [
                                CardField(
                                  title: 'Número do cartão',
                                  data: '• • • •  • • • •  • • • • ' +
                                      cardModel.finalNumber,
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  title: 'Nome do titular do cartão',
                                  data: cardModel.nameCardHolder,
                                ),
                              ],
                            ),
                            SizedBox(width: wXD(23, context)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardField(
                                  width: wXD(81, context),
                                  title: 'Data de vencimento',
                                  data: store
                                      .getFormatedDueDate(cardModel.dueDate),
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  width: wXD(81, context),
                                  title: 'CVC',
                                  data: '• • •',
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: wXD(40, context),
                      top: wXD(31, context),
                    ),
                    child: Text('Endereço de cobrança',
                        style: textFamily(
                          context,
                          fontSize: 17,
                          color: getColors(context).onBackground,
                        )),
                  ),
                  BillingAddress(
                    data: cardModel.billingState,
                  ),
                  BillingAddress(
                    data: cardModel.billingCity,
                  ),
                  BillingAddress(
                    data: cardModel.billingAddress,
                  ),
                  BillingAddress(
                    data: cardModel.billingCep,
                    mask: cepMask,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      wXD(40, context),
                      wXD(12, context),
                      wXD(40, context),
                      wXD(38, context),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Cartão principal',
                          style: textFamily(
                            context,
                            fontSize: 14,
                            color: blue,
                          ),
                        ),
                        Spacer(),
                        Switch(
                          value: main,
                          onChanged: (bool change) {
                            if (!itsUnic) {
                              setState(() {
                                main = change;
                              });
                              store.alteredMainCard(change, cardModel.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SideButton(
                    onTap: () => store.removeCard(context, cardModel.id),
                    title: 'Excluir cartão',
                    width: wXD(144, context),
                    height: wXD(52, context),
                  ),
                  SizedBox(height: wXD(28, context))
                ],
              ),
            ),
            DefaultAppBar('Detalhes do cartão'),
          ],
        ),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final double? width;
  final String title, data;
  CardField({this.width, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: textFamily(
              context,
              fontSize: 12,
              color: getColors(context).onPrimary,
            )),
        Container(
          width: width ?? wXD(160, context),
          height: wXD(31, context),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: getColors(context).onPrimary,
                      width: wXD(.5, context)))),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            initialValue: data,
            enabled: false,
            decoration: InputDecoration.collapsed(
                hintText: data,
                hintStyle: textFamily(
                  context,
                  color: getColors(context).onPrimary,
                )),
          ),
        )
      ],
    );
  }
}

class BillingAddress extends StatelessWidget {
  final MaskTextInputFormatter? mask;
  final String data;
  BillingAddress({
    this.mask,
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(43, context),
      width: maxWidth(context),
      padding: EdgeInsets.only(bottom: wXD(12, context)),
      margin: EdgeInsets.fromLTRB(
        wXD(40, context),
        wXD(0, context),
        wXD(40, context),
        wXD(25, context),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: getColors(context).onSurface.withOpacity(.4),
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        initialValue: mask != null ? mask!.maskText(data) : data,
        decoration: InputDecoration.collapsed(
          hintText: "",
          hintStyle: textFamily(
            context,
            fontSize: 14,
            color: getColors(context).onBackground.withOpacity(.7),
          ),
        ),
        enabled: false,
      ),
    );
  }
}

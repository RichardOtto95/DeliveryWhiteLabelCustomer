import 'package:delivery_customer/app/modules/payment/widgets/credit_card.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../payment_store.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final PaymentStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();

  final FocusNode cardNumberFocus = FocusNode();
  final FocusNode dueDateFocus = FocusNode();
  final FocusNode nameCardHolderFocus = FocusNode();
  final FocusNode cvcFocus = FocusNode();
  final FocusNode stateFocus = FocusNode();
  final FocusNode cityFocus = FocusNode();
  final FocusNode addressFocus = FocusNode();
  final FocusNode cepFocus = FocusNode();

  final MaskTextInputFormatter cardNumberMask = MaskTextInputFormatter(
      mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')});

  final MaskTextInputFormatter dueDateMask =
      MaskTextInputFormatter(mask: '##/##', filter: {"#": RegExp(r'[0-9]')});

  final MaskTextInputFormatter cvcMask =
      MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

  final MaskTextInputFormatter cepMask = MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  initState() {
    // cardNumberFocus.requestFocus();
    store.cardMap['main'] = false;
    super.initState();
  }

  @override
  dispose() {
    if (store.emailVerificationOverlay != null &&
        store.emailVerificationOverlay!.mounted) {
      store.emailVerificationOverlay!.remove();
    }

    if (store.noHasEmailOverlay != null && store.noHasEmailOverlay!.mounted) {
      store.noHasEmailOverlay!.remove();
    }

    cardNumberFocus.dispose();
    dueDateFocus.dispose();
    nameCardHolderFocus.dispose();
    cvcFocus.dispose();
    stateFocus.dispose();
    cityFocus.dispose();
    addressFocus.dispose();
    cepFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                          addCard: true,
                          onTap: () {
                            store.getColors();
                            setState(() {});
                          },
                        ),
                        SizedBox(height: wXD(33, context)),
                        Row(
                          children: [
                            SizedBox(width: wXD(41, context)),
                            Column(
                              children: [
                                CardField(
                                  title: 'Número do cartão',
                                  hint: 'xxxx xxxx xxxx xxxx',
                                  mask: cardNumberMask,
                                  focusNode: cardNumberFocus,
                                  textInputType: TextInputType.number,
                                  length: 16,
                                  onComplete: () => dueDateFocus.requestFocus(),
                                  onChanged: (String text) {
                                    store.cardMap['card_number'] = text;
                                  },
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  title: 'Nome do titular do cartão',
                                  hint: 'Fulano',
                                  focusNode: nameCardHolderFocus,
                                  textInputType: TextInputType.name,
                                  onComplete: () => cvcFocus.requestFocus(),
                                  onChanged: (String text) {
                                    store.cardMap['name_card_holder'] = text;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(width: wXD(23, context)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardField(
                                  width: wXD(125, context),
                                  title: 'Data de vencimento',
                                  hint: 'MM/AA',
                                  mask: dueDateMask,
                                  focusNode: dueDateFocus,
                                  textInputType: TextInputType.datetime,
                                  length: 4,
                                  onComplete: () =>
                                      nameCardHolderFocus.requestFocus(),
                                  validator: (String? text) {
                                    String value = text.toString();
                                    print(
                                        'vvvvvvvvvvvvvvvaaaaaaa ${value.length}');

                                    DateTime dateTimeNow = DateTime.now();
                                    int yearNow = dateTimeNow.year;
                                    int monthNow = dateTimeNow.month;

                                    String yearString =
                                        yearNow.toString().substring(0, 2) +
                                            value.substring(3, 5);
                                    int year = int.parse(yearString);

                                    String monthString = value.substring(0, 2);
                                    int month = int.parse(monthString);

                                    bool currentDate = year == yearNow;

                                    bool pastDate = yearNow > year;

                                    if (month > 12) {
                                      return 'Mês inválido.';
                                    }

                                    if (pastDate ||
                                        currentDate && monthNow >= month) {
                                      return 'Data inválida.';
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (String text) {
                                    store.cardMap['due_date'] = text;
                                  },
                                ),
                                SizedBox(height: wXD(23, context)),
                                CardField(
                                  width: wXD(125, context),
                                  title: 'CVC',
                                  hint: '999',
                                  mask: cvcMask,
                                  focusNode: cvcFocus,
                                  textInputType: TextInputType.number,
                                  length: 3,
                                  onComplete: () => stateFocus.requestFocus(),
                                  onChanged: (String text) {
                                    store.cardMap['security_code'] = text;
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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
                    hint: 'Estado',
                    focusNode: stateFocus,
                    minimumLength: 2,
                    onChanged: (String value) {
                      store.cardMap['billing_state'] = value;
                    },
                    onComplete: () => cityFocus.requestFocus(),
                  ),
                  BillingAddress(
                    hint: 'Cidade',
                    focusNode: cityFocus,
                    minimumLength: 2,
                    onChanged: (String value) {
                      store.cardMap['billing_city'] = value;
                    },
                    onComplete: () => addressFocus.requestFocus(),
                  ),
                  BillingAddress(
                    hint: 'Endereço',
                    focusNode: addressFocus,
                    minimumLength: 2,
                    onChanged: (String value) {
                      store.cardMap['billing_address'] = value;
                    },
                    onComplete: () => cepFocus.requestFocus(),
                  ),
                  BillingAddress(
                    hint: 'CEP',
                    mask: cepMask,
                    focusNode: cepFocus,
                    textInputType: TextInputType.number,
                    minimumLength: 8,
                    onChanged: (String value) {
                      store.cardMap['billing_cep'] = value;
                    },
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
                        Observer(builder: (context) {
                          return Switch(
                            value: store.cardMap['main'],
                            onChanged: (bool change) {
                              store.cardMap['main'] = change;
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  SideButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        store.addCard(context);
                      }
                    },
                    title: 'Adicionar',
                    width: wXD(142, context),
                    height: wXD(52, context),
                  ),
                  SizedBox(height: wXD(20, context))
                ],
              ),
            ),
            DefaultAppBar('Adicionar cartão'),
          ],
        ),
      ),
    );
  }
}

class CardField extends StatelessWidget {
  final double? width;
  final String title, hint;
  final FocusNode focusNode;
  final MaskTextInputFormatter? mask;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final void Function()? onComplete;
  final int? length;
  final TextInputType? textInputType;

  CardField({
    this.width,
    required this.title,
    required this.hint,
    required this.focusNode,
    required this.onChanged,
    this.mask,
    this.validator,
    this.onComplete,
    this.length,
    this.textInputType,
  });

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
          height: wXD(37, context),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: getColors(context).onPrimary,
                      width: wXD(.5, context)))),
          alignment: Alignment.centerLeft,
          child: TextFormField(
            keyboardType: textInputType!,
            cursorColor: getColors(context).primary,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: focusNode,
            inputFormatters: mask != null ? [mask!] : null,
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: textFamily(
                context,
                color: getColors(context).surface.withOpacity(0.8),
              ),
            ),
            style: textFamily(
              context,
              color: getColors(context).surface,
            ),
            validator: (String? val) {
              String _text = val.toString();
              if (mask != null) {
                _text = mask!.unmaskText(val!);
              }

              print('ccccccccccccccc validator $_text');

              if (_text == '') {
                return "Campo obrigatório";
              }

              if (length != null && length != _text.length) {
                return "Campo incompleto";
              }

              if (validator != null) {
                return validator!(val);
              }
            },
            onChanged: (txt) {
              String _text = txt;
              if (mask != null) {
                _text = mask!.unmaskText(txt);
              }
              onChanged(_text);
            },
            onEditingComplete: onComplete,
          ),
        )
      ],
    );
  }
}

class BillingAddress extends StatelessWidget {
  final String hint;
  final MaskTextInputFormatter? mask;
  final FocusNode focusNode;
  final TextInputType? textInputType;
  final int minimumLength;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final void Function()? onComplete;
  BillingAddress({
    required this.hint,
    required this.focusNode,
    required this.onChanged,
    this.mask,
    this.textInputType,
    this.minimumLength = 0,
    this.validator,
    this.onComplete,
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
                  color: getColors(context).onSurface.withOpacity(.4)))),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: textInputType,
        inputFormatters: mask != null ? [mask!] : [],
        focusNode: focusNode,
        cursorColor: getColors(context).primary,
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: textFamily(
            context,
            fontSize: 14,
            color: getColors(context).onBackground.withOpacity(.7),
          ),
        ),
        validator: (String? value) {
          if (value != null) {
            String _text = value;

            if (mask != null) {
              _text = mask!.unmaskText(value);
            }

            if (_text.isEmpty) {
              return 'Campo obrigatório';
            }

            if (_text.length < minimumLength) {
              return 'Campo incompleto';
            }

            if (validator != null) {
              return validator!(_text);
            }
          } else {
            return null;
          }
        },
        onChanged: (value) {
          String _text = value;
          if (mask != null) {
            _text = mask!.unmaskText(value);
          }
          onChanged(_text);
        },
        onEditingComplete: onComplete,
      ),
    );
  }
}

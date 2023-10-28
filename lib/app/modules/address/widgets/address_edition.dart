import 'dart:ui';

import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/modules/address/address_store.dart';
import 'package:delivery_customer/app/shared/widgets/responsive.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/custom_scroll_behavior.dart';
import '../../../shared/utilities.dart';

class AddressEdition extends StatefulWidget {
  final Address address;
  final bool editing;
  final void Function(Address?) onBack;

  AddressEdition({
    Key? key,
    required this.address,
    required this.onBack,
    this.editing = false,
  }) : super(key: key);

  @override
  _AddressEditionState createState() => _AddressEditionState();
}

class _AddressEditionState extends State<AddressEdition>
    with SingleTickerProviderStateMixin {
  final AddressStore addressStore = Modular.get();

  final _formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  late AnimationController _controller;

  late Address address;

  double height = 0;

  FocusNode numberFocus = FocusNode();
  FocusNode complementFocus = FocusNode();
  FocusNode neighborhoodFocus = FocusNode();

  Future<void> animateTo(double val) => _controller.animateTo(val,
      curve: Curves.easeOutQuad, duration: Duration(milliseconds: 400));

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    animateTo(1);

    address = widget.address;

    numberFocus.addListener(() async {
      if (numberFocus.hasFocus && !Responsive.isDesktop(context)) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    complementFocus.addListener(() async {
      if (complementFocus.hasFocus && !Responsive.isDesktop(context)) {
        height = 100;
        setState(() {});
        print("height = 100");

        await Future.delayed(Duration(milliseconds: 300));
        print("Animating");
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        setState(() {
          height = 0;
        });
      }
    });

    neighborhoodFocus.addListener(() async {
      if (neighborhoodFocus.hasFocus && !Responsive.isDesktop(context)) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    numberFocus.removeListener(() {});
    numberFocus.dispose();
    complementFocus.removeListener(() {});
    complementFocus.dispose();
    neighborhoodFocus.removeListener(() {});
    neighborhoodFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = _controller.value;
            return Material(
              color: Colors.transparent,
              child: Listener(
                onPointerDown: (event) =>
                    FocusScope.of(context).requestFocus(FocusNode()),
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: value * 2 + 0.001,
                        sigmaY: value * 2 + 0.001,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          await animateTo(0);
                          widget.onBack(null);
                        },
                        child: Container(
                          height: maxHeight(context),
                          width: maxWidth(context),
                          color:
                              getColors(context).shadow.withOpacity(value * .3),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Positioned(
                      width: maxWidth(context),
                      height: maxHeight(context),
                      top: maxHeight(context) - maxHeight(context) * value,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => widget.onBack(null),
                              child: Container(
                                color: Colors.transparent,
                                height: wXD(141, context),
                                width: maxWidth(context),
                              ),
                            ),
                            Container(
                              // height: hXD(526, context),
                              width: maxWidth(context),
                              padding: EdgeInsets.only(top: wXD(24, context)),
                              decoration: BoxDecoration(
                                color: getColors(context).surface,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(3)),
                              ),
                              child: ScrollConfiguration(
                                behavior: CustomScrollBehavior(),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              width: maxWidth(context),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Conferir endereço',
                                                style: textFamily(
                                                  context,
                                                  fontSize: 15,
                                                  color: getColors(context)
                                                      .onSurface,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: wXD(26, context),
                                              child: InkWell(
                                                onTap: () =>
                                                    widget.onBack(null),
                                                child: Icon(
                                                  Icons.close,
                                                  size: wXD(22, context),
                                                  color: Color(0xff241332)
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: wXD(21, context),
                                            right: wXD(21, context),
                                            top: wXD(28, context),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Esse é o endereço do local indicado no mapa.',
                                                style: textFamily(
                                                  context,
                                                  fontSize: 14,
                                                  color: getColors(context)
                                                      .primary,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                'Você pode editar o texto, se necessário.',
                                                style: textFamily(context,
                                                    fontSize: 14,
                                                    color: getColors(context)
                                                        .onSurface,
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.4),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AddressField(
                                          'Nome',
                                          initialValue: address.addressName,
                                          onChanged: (val) {
                                            address.addressName = val;
                                          },
                                        ),
                                        AddressField(
                                          'CEP',
                                          textInputType: TextInputType.number,
                                          initialValue: cepMask
                                              .maskText(address.cep ?? ''),
                                          inputFormatters: [cepMask],
                                          onChanged: (val) => address.cep =
                                              cepMask.unmaskText(val),
                                          enabled: true,
                                          validate: true,
                                          validator: (txt) {
                                            if (txt != null && txt.length < 8) {
                                              return "Preencha o campo por completo";
                                            }
                                            return null;
                                          },
                                        ),
                                        AddressField(
                                          'Cidade',
                                          enabled: false,
                                          initialValue: address.city,
                                        ),
                                        AddressField(
                                          'Estado',
                                          enabled: false,
                                          initialValue: address.state,
                                        ),
                                        AddressField(
                                          'Bairro',
                                          onChanged: (val) {
                                            address.neighborhood = val;
                                          },
                                          initialValue: address.neighborhood,
                                          focus: neighborhoodFocus,
                                        ),
                                        AddressField(
                                          'Endereço',
                                          initialValue: address.formatedAddress,
                                          onChanged: (val) =>
                                              address.formatedAddress = val,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: wXD(18, context)),
                                            AddressField(
                                              'Número',
                                              width: wXD(120, context),
                                              initialValue:
                                                  address.addressNumber,
                                              onChanged: (val) {
                                                address.addressNumber = val;
                                              },
                                              focus: numberFocus,
                                            ),
                                            SizedBox(width: wXD(12, context)),
                                            AddressField(
                                              'Complemento',
                                              width: wXD(207, context),
                                              onChanged: (val) {
                                                address.addressComplement = val;
                                                ;
                                              },
                                              initialValue:
                                                  address.addressComplement,
                                              validate:
                                                  !address.withoutComplement!,
                                              focus: complementFocus,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: maxWidth(context),
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(
                                            top: wXD(23, context),
                                            left: wXD(15, context),
                                            bottom: wXD(38, context),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    address.withoutComplement =
                                                        !address
                                                            .withoutComplement!;
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: wXD(20, context),
                                                      width: wXD(20, context),
                                                      margin: EdgeInsets.only(
                                                          right:
                                                              wXD(3, context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        border: Border.all(
                                                          color:
                                                              getColors(context)
                                                                  .onSurface,
                                                        ),
                                                        color: address
                                                                .withoutComplement!
                                                            ? getColors(context)
                                                                .primary
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Não tenho complemento',
                                                      style: textFamily(
                                                        context,
                                                        fontSize: 13,
                                                        color:
                                                            getColors(context)
                                                                .onSurface,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                  height: wXD(12, context)),
                                              GestureDetector(
                                                onTap: () => setState(() {
                                                  address.main = !address.main!;
                                                }),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: wXD(20, context),
                                                      width: wXD(20, context),
                                                      margin: EdgeInsets.only(
                                                          right:
                                                              wXD(3, context)),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        border: Border.all(
                                                          color:
                                                              getColors(context)
                                                                  .onSurface,
                                                        ),
                                                        color: address.main!
                                                            ? getColors(context)
                                                                .primary
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Definir como principal',
                                                      style: textFamily(
                                                        context,
                                                        fontSize: 13,
                                                        color:
                                                            getColors(context)
                                                                .onSurface,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SideButton(
                                          onTap: () async {
                                            // addressStore.setCheckLocation(false);
                                            // print("homeRoot: $homeRoot");

                                            if (_formKey.currentState!
                                                .validate()) {
                                              // if (widget.editing) {
                                              //   await addressStore.newAddress(
                                              //       address,
                                              //       context,
                                              //       widget.editing);
                                              //   widget.onBack(null);
                                              // } else {
                                              await addressStore.newAddress(
                                                address,
                                                context,
                                                widget.editing,
                                              );
                                              widget.onBack(null);
                                              // }
                                            }
                                          },
                                          title: 'Salvar',
                                          width: wXD(142, context),
                                          height: wXD(52, context),
                                        ),
                                        SizedBox(height: wXD(16, context)),
                                        TextButton(
                                          onPressed: () async {
                                            await animateTo(0);

                                            widget.onBack(address);
                                          },
                                          child: Text(
                                            'Alterar local no mapa',
                                            style: textFamily(context,
                                                fontSize: 14,
                                                color:
                                                    getColors(context).primary),
                                          ),
                                        ),
                                        SizedBox(height: wXD(17, context)),
                                        Container(height: wXD(height, context)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class AddressField extends StatelessWidget {
  final double? width;
  final String title;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool validate;
  final bool enabled;
  final void Function(String)? onChanged;
  final FocusNode? focus;
  final String? Function(String?)? validator;
  final TextInputType? textInputType;

  AddressField(
    this.title, {
    this.width,
    this.initialValue,
    this.inputFormatters,
    this.validate = true,
    this.onChanged,
    this.enabled = true,
    this.focus,
    this.validator,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? wXD(339, context),
      margin: EdgeInsets.only(top: wXD(29, context)),
      padding: EdgeInsets.fromLTRB(
        wXD(8, context),
        wXD(6, context),
        wXD(8, context),
        wXD(6, context),
      ),
      decoration: BoxDecoration(
        border:
            Border.all(color: getColors(context).onBackground.withOpacity(.3)),
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: getColors(context).surface,
        boxShadow: [
          BoxShadow(
            blurRadius: wXD(7, context),
            offset: Offset(0, wXD(10, context)),
            color: getColors(context).shadow,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textFamily(
              context,
              fontSize: 15,
              color: Color(0xff898989).withOpacity(.7),
              // fontWeight: FontWeight.w400,
              // height: 1.4
            ),
          ),
          Container(
            width: wXD(315, context),
            child: TextFormField(
              keyboardType: textInputType,
              focusNode: focus,
              enabled: enabled,
              onChanged: onChanged,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) {
                if (validate) {
                  if (val != null && val.isEmpty) {
                    return "Preencha o campo corretamente";
                  }
                  if (validator != null) {
                    return validator!(val);
                  }
                }
              },
              initialValue: initialValue,
              inputFormatters: inputFormatters,
              decoration: InputDecoration.collapsed(hintText: ''),
            ),
          ),
        ],
      ),
    );
  }
}

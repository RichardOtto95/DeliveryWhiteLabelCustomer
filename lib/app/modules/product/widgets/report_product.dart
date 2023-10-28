import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../product_store.dart';

class ReportProduct extends StatefulWidget {
  final String adsId;
  ReportProduct({Key? key, required this.adsId}) : super(key: key);

  @override
  _ReportProductState createState() => _ReportProductState();
}

class _ReportProductState extends State<ReportProduct> {
  final ProductStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    store.reportPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    store.reportPageController.dispose();
    super.dispose();
  }

  String justify = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.reportPageController.page == 1) {
          await store.reportPageController.animateToPage(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          return false;
        }
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              PageView(
                controller: store.reportPageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: viewPaddingTop(context) + wXD(60, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: wXD(10, context),
                            top: wXD(14, context),
                            bottom: wXD(14, context),
                          ),
                          child: Text(
                            "Selecione o motivo",
                            style: textFamily(context,
                                fontSize: 15,
                                color: getColors(context).onBackground),
                          ),
                        ),
                        ReportTile(text: "Falsificações e Direitos autorais"),
                        ReportTile(text: "Itens proíbidos (Banidos)"),
                        ReportTile(
                            text:
                                "Violação das Políticas de Listagem (Palavras-chave inadequadas, Links externos, etc."),
                        ReportTile(
                            text:
                                "Itens ovensivos e/ou protencialmente ofensivos"),
                        ReportTile(
                            text:
                                "Listagens Fradulentas (demandas de vendedores ilegais, etc."),
                        ReportTile(text: "Propriedade furtada"),
                        ReportTile(text: "Outros"),
                      ],
                    ),
                  ),
                  Container(
                    height: maxHeight(context),
                    width: maxWidth(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: wXD(15, context),
                            top: viewPaddingTop(context) + wXD(60, context),
                            bottom: wXD(14, context),
                          ),
                          child: Text(
                            "Digite a sua justificativa",
                            style: textFamily(context,
                                fontSize: 15,
                                color: getColors(context).onBackground),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            width: maxWidth(context),
                            margin: EdgeInsets.symmetric(
                                horizontal: wXD(15, context)),
                            padding: EdgeInsets.symmetric(
                                horizontal: wXD(8, context),
                                vertical: wXD(5, context)),
                            height: wXD(200, context),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: getColors(context).primary),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: TextFormField(
                              maxLines: 20,
                              decoration: InputDecoration.collapsed(
                                  hintText: "Escreva sua justificativa aqui"),
                              maxLength: 500,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (val) => justify = val,
                              validator: (val) {
                                if (val == null || val == '') {
                                  return "Sua justificativa não pode ser vazia";
                                } else if (val.length < 15) {
                                  return "Sua justificativa deve ter no mínimo 15 caracteres";
                                }
                              },
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                        SideButton(
                          width: wXD(150, context),
                          height: wXD(65, context),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              store.reportProduct(
                                  justify, widget.adsId, context);
                            } else {
                              showToast("Verifique o campo e tente novamente");
                            }
                          },
                          title: "Denunciar",
                        ),
                        Spacer(),
                        // Center(
                        //   child: Container(
                        //     margin: EdgeInsets.only(bottom: wXD(20, context)),
                        //     height: wXD(50, context),
                        //     width: wXD(200, context),
                        //     decoration: BoxDecoration(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(7)),
                        //       gradient: LinearGradient(
                        //         begin: Alignment.topLeft,
                        //         end: Alignment.bottomRight,
                        //         colors: [
                        //          getColors(context).primary,
                        //          getColors(context).primary.withOpacity(.7),
                        //           //getColors(context).primary.withOpacity(.6),
                        //           //getColors(context).primary.withOpacity(.4),
                        //         ],
                        //       ),
                        //     ),
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       "Denunciar",
                        //       style: textFamily(context,
                        //         fontSize: 16,
                        //         color: white,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              ),
              DefaultAppBar(
                "Denunciar produto",
                onPop: () {
                  if (store.reportPageController.page == 1) {
                    store.reportPageController.animateToPage(0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else {
                    Modular.to.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final ProductStore store = Modular.get();

  final String text;
  ReportTile({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        store.reportReason = text;
        store.reportPageController.animateToPage(1,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: wXD(10, context),
          vertical: wXD(14, context),
        ),
        width: maxWidth(context),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: getColors(context).onSurface.withOpacity(.3),
                    width: wXD(.5, context)))),
        child: Row(
          children: [
            Container(
              width: wXD(330, context),
              child: Text(
                text,
                style: textFamily(context, fontSize: 15),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: getColors(context).primary,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/home/home_store.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';

class WasInvited extends StatefulWidget {
  const WasInvited({
    Key? key,
  }) : super(key: key);
  @override
  _WasInvitedState createState() => _WasInvitedState();
}

class _WasInvitedState extends ModularState<WasInvited, HomeStore> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Listener(
        // onPointerDown: (a) =>
        //     FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: wXD(53, context) + viewPaddingTop(context)),
                  width: maxWidth(context),
                  height: maxHeight(context),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(flex: 3),
                      Image.asset(
                        brightness == Brightness.light
                            ? "./assets/images/logo.png"
                            : "./assets/images/logo_dark.png",
                        width: wXD(173, context),
                        height: wXD(153, context),
                      ),
                      Spacer(),
                      // SizedBox(height: wXD(10, context)),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('info')
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator(
                                color: getColors(context).primary,
                                backgroundColor:
                                    getColors(context).primary.withOpacity(0.4),
                              );
                            }
                            QuerySnapshot infoQuery = snapshot.data!;
                            DocumentSnapshot infoDoc = infoQuery.docs.first;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: wXD(30, context)),
                              child: Column(
                                children: [
                                  Text(
                                    // "Algum amigo que te indicou ao Mercado Expresso?",
                                    infoDoc['first_promo_code_screen_title'],
                                    textAlign: TextAlign.center,
                                    style: textFamily(
                                      context,
                                      fontSize: 20,
                                      color: getColors(context).onBackground,
                                    ),
                                  ),
                                  SizedBox(height: wXD(18, context)),
                                  Text(
                                    infoDoc[
                                        'first_promo_code_screen_description'],
                                    textAlign: TextAlign.center,
                                    style: textFamily(
                                      context,
                                      fontSize: 18,
                                      color: getColors(context).onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Spacer(flex: 2),

                      Form(
                        key: _formKey,
                        child: Container(
                          width: maxWidth(context),
                          margin: EdgeInsets.symmetric(
                              horizontal: wXD(30, context)),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(8, context),
                              vertical: wXD(15, context)),
                          // height: wXD(200, context),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: getColors(context).primary),
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration.collapsed(
                                hintText: "Insira o código aqui...",
                                hintStyle: textFamily(
                                  context,
                                )),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              store.promotionalCode = value;
                            },
                            validator: (val) {
                              if (val == null || val == '') {
                                return "Esse campo não pode ser vazio";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      GestureDetector(
                        onTap: () => store.setWasInvited(true, context),
                        child: Container(
                          width: wXD(200, context),
                          height: wXD(50, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: getColors(context).primary,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                offset: Offset(0, 3),
                                color: getColors(context).shadow,
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Ativar código",
                            style: textFamily(
                              context,
                              color: getColors(context).onPrimary,
                            ),
                          ),
                        ),
                      ),
                      // TextButton.icon(
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       print('onpressed');
                      //       store.setWasInvited(true, context);
                      //     }
                      //   },
                      //   icon: Icon(
                      //     Icons.find_replace_outlined,
                      //     color: getColors(context).primary,
                      //   ),
                      //   label: Text(
                      //     "Buscar",
                      //     style: TextStyle(
                      //       color: getColors(context).primary,
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: wXD(40, context),
                            vertical: wXD(7, context)),
                        child: Text(
                          "Ao ativar o código você ganhará um desconto no valor de R\$ 5,00!",
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 11,
                            color:
                                getColors(context).onBackground.withOpacity(.6),
                          ),
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
              DefaultAppBar(
                "Atenção",
                onPop: () => store.setWasInvited(false, context),
              ),
              Positioned(
                top: viewPaddingTop(context),
                right: wXD(10, context),
                child: IconButton(
                  onPressed: () => store.setWasInvited(false, context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: getColors(context).primary,
                    size: wXD(30, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

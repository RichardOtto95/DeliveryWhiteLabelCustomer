import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'sign_email_store.dart';
import 'widgets/text_field_widget.dart';

class SignPageEmail extends StatefulWidget {
  const SignPageEmail({Key? key}) : super(key: key);

  @override
  _SignPageEmailState createState() => _SignPageEmailState();
}

class _SignPageEmailState extends State<SignPageEmail> {
  // stores
  final SignEmailStore store = Modular.get();
  final AuthStore authStore = Modular.get();

  // variables
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  // final FocusNode confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    // confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => store.canBack,
      child: Listener(
        onPointerDown: (a) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            store.back();

            return true;
          },
          child: Scaffold(
            body: Observer(builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset(
                        './assets/images/logo_signin.png',
                        width: wXD(173, context),
                        height: wXD(153, context),
                      ),
                      Spacer(),
                      Text(
                        'Bem vindo',
                        textAlign: TextAlign.center,
                        style: textFamily(
                          context,
                          fontSize: 28,
                          color: getColors(context).onBackground,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Cadastre-se para entrar',
                        textAlign: TextAlign.center,
                        style: textFamily(
                          context,
                          fontSize: 20,
                          color:
                              getColors(context).onBackground.withOpacity(0.8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Spacer(flex: 2),
                      Form(
                        key: _formKey,
                        child: Container(
                          width: wXD(235, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                title: 'E-mail',
                                controller: store.emailController,
                                focusNode: emailFocus,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }

                                  bool emailValid = RegExp(
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                      .hasMatch(value);

                                  if (!emailValid) {
                                    return 'Digite um e-mail válido';
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (String value) {
                                  store.email = value;
                                },
                                onComplete: () => passwordFocus.requestFocus(),
                              ),
                              SizedBox(height: wXD(15, context)),
                              TextFieldWidget(
                                title: 'Senha',
                                controller: store.passwordController,
                                focusNode: passwordFocus,
                                password: true,
                                validator: (String value) {
                                  if (store.password == '') {
                                    return 'Campo obrigatório';
                                  }

                                  // if (store.password.length < 8) {
                                  //   return 'Mínimo de 8 dígitos';
                                  // }
                                  return null;
                                },
                                onChanged: (String value) {
                                  store.password = value;
                                },
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: 7,
                                  ),
                                  TextButton(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1),
                                        ),
                                      ),
                                      padding: EdgeInsets.only(
                                          bottom: wXD(3, context)),
                                      child: Text(
                                        'Criar conta',
                                        style: textFamily(
                                          context,
                                          color:
                                              getColors(context).onBackground,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      store.back();
                                      Modular.to.pushNamed('/sign-up-email');
                                    },
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        store.back();
                                        Modular.to.pop();
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Positioned(
                                            left: 0,
                                            child: Icon(Icons.phone_android),
                                          ),
                                          Container(
                                            width: wXD(170, context),
                                            height: wXD(40, context),
                                            alignment: Alignment.center,
                                            child: Text("Logar com telefone",
                                                style: textFamily(
                                                  context,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      SideButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            store.verifyEmail(context);
                          }
                        },
                        title: 'Entrar',
                        height: wXD(52, context),
                        width: wXD(142, context),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

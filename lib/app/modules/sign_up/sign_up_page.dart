import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'sign_up_store.dart';
import 'widgets/text_field_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // stores
  final SignUpStore store = Modular.get();
  final AuthStore authStore = Modular.get();

  // variables
  final _formKey = GlobalKey<FormState>();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode confirmPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (a) =>
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: WillPopScope(
        onWillPop: () async {
          store.back();

          return store.canBack;
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
                        color: getColors(context).onBackground.withOpacity(0.8),
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

                                if (store.password.length < 8) {
                                  return 'Mínimo de 8 dígitos';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                store.password = value;
                              },
                              onComplete: () =>
                                  confirmPasswordFocus.requestFocus(),
                            ),
                            SizedBox(height: wXD(15, context)),
                            TextFieldWidget(
                              title: 'Confirme a senha',
                              controller: store.confirmPasswordController,
                              focusNode: confirmPasswordFocus,
                              password: true,
                              validator: (String value) {
                                if (store.confirmPassword == '') {
                                  return 'Campo obrigatório';
                                }
                                if (store.password != store.confirmPassword) {
                                  return 'Senhas diferentes';
                                }
                                return null;
                              },
                              onChanged: (String value) {
                                store.confirmPassword = value;
                              },
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  store.back();
                                  Modular.to.pushNamed('/sign-phone');
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
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    SideButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          store.createUserWithEmail(context);
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
    );
  }
}

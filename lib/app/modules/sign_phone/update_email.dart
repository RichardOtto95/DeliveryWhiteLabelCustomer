import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/modules/sign_phone/sign_phone_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({Key? key}) : super(key: key);

  @override
  _UpdateEmailState createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  final SignPhoneStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (a) =>
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: Observer(builder: (context) {
            return Column(
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
                  'Quase lá',
                  textAlign: TextAlign.center,
                  style: textFamily(
                    context,
                    fontSize: 28,
                    color: getColors(context).onBackground,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Só falta um e-mail válido',
                  textAlign: TextAlign.center,
                  style: textFamily(
                    context,
                    fontSize: 20,
                    color: getColors(context).onBackground.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(flex: 2),
                Container(
                  width: wXD(235, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'E-mail',
                        style: textFamily(
                          context,
                          fontSize: 20,
                          color:
                              getColors(context).onBackground.withOpacity(.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          style: textFamily(context, fontSize: 20),
                          // keyboardType: TextInputType.phone,
                          controller: _emailController,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            print('onChanged $value - ${value.length}');
                            store.updateEmail = value;
                          },
                          validator: (value) {
                            if (store.updateEmail == '') {
                              return 'Campo obrigatório';
                            }

                            bool emailValid = RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(value!);

                            if (!emailValid) {
                              return 'Digite um e-mail válido';
                            }

                            return null;
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: black.withOpacity(.3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                SideButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      store.updateUserEmail(context);
                    }
                  },
                  title: 'Pronto',
                  height: wXD(52, context),
                  width: wXD(142, context),
                ),
                Spacer(),
              ],
            );
          }),
        ),
      ),
    );
  }
}

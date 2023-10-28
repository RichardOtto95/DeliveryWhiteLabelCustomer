import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../profile_store.dart';

class ConfirmCode extends StatelessWidget {
  final ProfileStore store = Modular.get();
  final void Function() cancel;
  final void Function() resend;
  final void Function() confirm;
  final String numberPhone;

  ConfirmCode({
    required this.cancel,
    required this.resend,
    required this.confirm,
    required this.numberPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        // onTap: () {
        //   store.confirmCodeOverlay!.remove();
        // },
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: () {
                store.confirmCodeOverlay!.remove();
              },
              child: Container(
                height: maxHeight(context),
                width: maxWidth(context),
                color: black.withOpacity(.5),
                padding: EdgeInsets.symmetric(
                    vertical: hXD(165, context), horizontal: wXD(25, context)),
                alignment: Alignment.center,
                // child:
              ),
            ),
            Container(
              height: wXD(400, context),
              width: wXD(300, context),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(28))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: wXD(1, context)),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: Icon(
                          Icons.info_outline,
                          size: wXD(20, context),
                        ),
                      ),
                      Container(
                        width: wXD(130, context),
                        alignment: Alignment.center,
                        child: Text(
                          'Observação',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff484D54),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: wXD(279, context),
                    child: Text(
                      'Por questões de segurança, ao atualizar o e-mail ou o telefone, precisamos de uma autenticação recente. Por isso será enviado outro código via sms para o seu número.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff484D54),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    width: wXD(279, context),
                    child: Text(
                      'Digite o código enviado para ${getMask(numberPhone)}.',
                      style: TextStyle(
                        fontSize: wXD(15, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xff484D54),
                      ),
                    ),
                  ),
                  Container(
                    width: wXD(279, context),
                    child: PinCodeTextField(
                      keyboardType: TextInputType.number,
                      length: 6,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 50,
                          fieldWidth: 40,
                          inactiveColor: Colors.grey[400], //
                          activeColor: getColors(context).primary,
                          selectedColor: getColors(context).secondary),
                      backgroundColor: white,
                      animationDuration: Duration(milliseconds: 300),
                      onCompleted: (value) async {
                        print('xxxxxxxx onCompleted $value xxxxxxxxxxx');

                        store.loadCircularCode = true;

                        confirm();
                      },
                      onChanged: (value) {
                        store.code = value;
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                      appContext: context,
                    ),
                  ),
                  Observer(builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: store.loadCircularCode
                          ? [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    getColors(context).primary),
                              ),
                            ]
                          : [
                              Button(
                                text: 'Cancelar',
                                onTap: cancel,
                              ),
                              Button(
                                text: store.timerSeconds == null
                                    ? 'Reenviar'
                                    : store.timerSeconds.toString(),
                                onTap: store.timerSeconds == null
                                    ? resend
                                    : () {
                                        showToast(
                                            'Espere ${store.timerSeconds} segundo(s) para enviar outro código.');
                                      },
                              ),
                            ],
                    );
                  }),
                  SizedBox(height: wXD(3, context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getMask(String numberPhone) {
    String numberFormated =
        '${numberPhone.substring(0, 3)} (' + '${numberPhone.substring(3, 5)}) ';

    numberFormated +=
        '${numberPhone.substring(5, 10)}-' + numberPhone.substring(10, 14);

    return numberFormated;
  }
}

class Button extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const Button({
    Key? key,
    this.text = "Sim",
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(47, context),
        width: wXD(98, context),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 3,
                  color: getColors(context).shadow)
            ],
            borderRadius: BorderRadius.all(Radius.circular(17)),
            border: Border.all(color: Color(0x80707070)),
            color: white),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: getColors(context).primary,
              fontWeight: FontWeight.bold,
              fontSize: wXD(16, context)),
        ),
      ),
    );
  }
}

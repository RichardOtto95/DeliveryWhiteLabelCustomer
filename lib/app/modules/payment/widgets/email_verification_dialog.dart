import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../payment_store.dart';

class EmailVerificationDialog extends StatelessWidget {
  final void Function() onCancel;
  final String title;
  final String? email;

  EmailVerificationDialog({
    Key? key,
    required this.onCancel,
    required this.title,
    required this.email,
  });

  final PaymentStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: onCancel,
            child: AnimatedContainer(
              height: maxHeight(context),
              width: maxWidth(context),
              color: Color(0x50000000),
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate,
              alignment: Alignment.center,
            ),
          ),
          InkWell(
            onTap: () {
              print('on tap 2');
            },
            child: Container(
              height: wXD(250, context),
              width: wXD(324, context),
              decoration: BoxDecoration(
                  color: Color(0xfffafafa),
                  borderRadius: BorderRadius.all(Radius.circular(28))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: wXD(17, context)),
                    alignment: Alignment.center,
                    child: Text(
                      'Atenção',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff484D54),
                      ),
                    ),
                  ),
                  Container(
                    width: wXD(290, context),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color(0xff484D54),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    width: wXD(253, context),
                    margin: EdgeInsets.only(top: wXD(15, context)),
                    child: Text(
                      'O e-mail $email ainda não foi validado, deseja atualizá-lo no perfil ou reenviar o link mágico?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff484D54),
                      ),
                    ),
                  ),
                  Spacer(flex: 1),
                  Observer(
                    builder: (context) {
                      return store.loadCircularEmailVerification
                          ? Row(
                              children: [
                                Spacer(),
                                CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                                Spacer()
                              ],
                            )
                          : Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await store.pushProfile();
                                  },
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17)),
                                        border: Border.all(
                                            color: Color(0x80707070)),
                                        color: Color(0xfffafafa)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Atualizar',
                                      style: TextStyle(
                                        color: getColors(context).primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await store.resendVerificationEmail();
                                  },
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(17)),
                                        border: Border.all(
                                            color: Color(0x80707070)),
                                        color: Color(0xfffafafa)),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Reenviar',
                                      style: TextStyle(
                                        color: getColors(context).primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            );
                    },
                  ),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:delivery_customer/app/core/models/customer_model.dart';
import 'package:delivery_customer/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'sign_email_store.g.dart';

class SignEmailStore = _SignEmailStoreBase with _$SignEmailStore;

abstract class _SignEmailStoreBase with Store {
  final AuthStore authStore = Modular.get();
  late final Customer customer;
  final AuthServiceInterface authService = Modular.get();

  @observable
  TextEditingController emailController = TextEditingController();
  @observable
  TextEditingController passwordController = TextEditingController();

  @observable
  String email = '';
  @observable
  String password = '';
  @observable
  bool canBack = true;

  @action
  back() {
    email = '';
    password = '';
    emailController.clear();
    passwordController.clear();
  }

  @action
  verifyEmail(BuildContext context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(overlayEntry);
    canBack = false;

    Map result = await authStore.siginEmail(email, password);

    print(result);
    print(result['code']);

    if (result['code'] == 'success') {
      // valueUser = result['user'];
      back();
    }

    if (result['code'] == 'invalid-email') {
      showToast('E-mail inválido!');
    }

    if (result['code'] == 'user-not-found') {
      showToast('Não há usuário com este e-mail!');
    }

    if (result['code'] == 'user-disabled') {
      showToast('Esse usuário foi desativado!');
    }

    if (result['code'] == 'wrong-password') {
      showToast('Senha incorreta!');
    }
    canBack = true;

    overlayEntry.remove();
  }
}

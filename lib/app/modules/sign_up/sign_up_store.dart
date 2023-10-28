import 'package:delivery_customer/app/core/models/customer_model.dart';
import 'package:delivery_customer/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'sign_up_store.g.dart';

class SignUpStore = _SignUpStoreBase with _$SignUpStore;

abstract class _SignUpStoreBase with Store {
  final AuthStore authStore = Modular.get();
  late final Customer customer;
  final AuthServiceInterface authService = Modular.get();

  @observable
  TextEditingController emailController = TextEditingController();
  @observable
  TextEditingController passwordController = TextEditingController();
  @observable
  TextEditingController confirmPasswordController = TextEditingController();

  @observable
  String email = '';
  @observable
  String password = '';
  @observable
  String confirmPassword = '';
  @observable
  bool canBack = true;

  @action
  back() {
    email = '';
    password = '';
    confirmPassword = '';
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @action
  createUserWithEmail(context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(overlayEntry);
    canBack = false;

    Map result = await authStore.createUserWithEmail(email, confirmPassword);

    print(result);
    print(result['code']);

    if (result['code'] == 'success') {
      // valueUser = result['user'];
      back();
    }

    if (result['code'] == 'invalid-email') {
      showToast('E-mail inválido!');
    }

    if (result['code'] == 'email-already-in-use') {
      showToast('Esse e-mail já está em uso!');
    }

    if (result['code'] == 'operation-not-allowed') {
      showToast('OPS... erro inesperado, contate o suporte.');
    }

    if (result['code'] == 'weak-password') {
      showToast('Senha fraca!');
    }
    canBack = true;

    overlayEntry.remove();
  }
}

import 'package:delivery_customer/app/core/services/auth/auth_service_interface.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
// import 'package:delivery_customer/app/core/models/customer_model.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';
part 'sign_phone_store.g.dart';

class SignPhoneStore = _SignPhoneStoreBase with _$SignPhoneStore;

abstract class _SignPhoneStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final AuthServiceInterface authService = Modular.get();
  // @observable
  // User? valueUser;
  @observable
  String? phone;
  @observable
  int resendingSeconds = 0;
  // @observable
  // Observable<int> resendingSMSSeconds = 0.obs();
  @observable
  Timer? resendingSMSTimer;
  @observable
  String updateEmail = '';
  @observable
  OverlayEntry? loadOverlay;

  @observable
  _SignPhoneStoreBase();

  // @computed
  // int get getResendingSMSSeconds => resendingSeconds.value;

  // @action
  // void setResendingSMSSeconds(int seconds) => resendingSeconds = seconds.obs();

  @action
  void setPhone(_phone) => phone = _phone;

  // @action
  // int getStart() => start;

  @action
  verifyNumber(BuildContext context) async {
    loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);

    print('##### phone $phone');
    String userPhone = '+55' + phone!;
    print('##### userPhone $userPhone');
    await authStore.verifyNumber(
      userPhone,
      context,
      removeLoad: (){
        loadOverlay!.remove();
        loadOverlay = null;
      },
      timerInit: (){
        // setResendingSMSSeconds(60);
        resendingSeconds = 60;
        // print('timerInit: ${resendingSeconds.value}');
        print('timerInit: $resendingSeconds');
        resendingSMSTimer = Timer.periodic(Duration(seconds: 1), (timer) { 
          // resendingSeconds.value --;
          resendingSeconds--;
          // print("resendingSMSSeconds.value: ${resendingSeconds.value}");
          print("resendingSMSSeconds.value: $resendingSeconds");
          // if(resendingSeconds.value == 0){
          if(resendingSeconds == 0){
            timer.cancel();
          }
        });
      }
    );
  }

  @action
  signinPhone(String _code, context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    await authStore.handleSmsSignin(_code);

    overlayEntry.remove();
  }

  @action
  updateUserEmail(context) async {
    OverlayEntry overlayEntry =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    print('updateUserPhone');
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.currentUser!.updateEmail(updateEmail);
      await authService.handleSignup();
      Modular.to.pushNamed('/address', arguments: true);
      print('email atualizado!!!');
    } on FirebaseAuthException catch (error) {
      print('erro ao atualizar!!!');
      print(error);
      print(error.code);

      if (error.code == 'email-already-in-use') {
        showToast('O e-mail digitado já está em uso!');
      }
      if (error.code == 'invalid-email') {
        showToast('E-mail inválido!');
      }
    }
    overlayEntry.remove();
  }

  @action
  void resendingSMS(context){
    loadOverlay = OverlayEntry(builder: (context) => const LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);
    String userPhone = '+55' + phone!;

    authStore.resendingSMS(
      userPhone,      
      removeLoadOverlay: (){
        loadOverlay!.remove();
        loadOverlay = null;
      },
      timerInit: (){
        // setResendingSMSSeconds(60);
        resendingSeconds = 60;
        resendingSMSTimer = Timer.periodic(Duration(seconds: 1), (timer) { 
          // resendingSeconds.value --;
          resendingSeconds--;
          // if(resendingSeconds.value == 0){
          if(resendingSeconds == 0){
            timer.cancel();
          }
        });
      },
    );
  }
}

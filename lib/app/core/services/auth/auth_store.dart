import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:delivery_customer/app/core/models/customer_model.dart';
import 'package:delivery_customer/app/core/modules/root/root_store.dart';
// import 'package:delivery_customer/app/core/utils/auth_status_enum.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import '../../../shared/widgets/load_circular_overlay.dart';
import 'auth_service.dart';
import 'package:universal_html/html.dart' as html;
part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  // _AuthStoreBase() {
  //   _authService.handleGetUser().then(setUser);
  // }
  final AuthService _authService = Modular.get();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RootStore rootController = Modular.get();

  // Customer customerModel = Customer();
  // @observable
  // AuthStatus status = AuthStatus.loading;
  @observable
  String? userVerificationId;
  @observable
  int? userForceResendingToken;
  // @observable
  // String mobile = '';
  // @observable
  // String? phoneMobile;
  // @observable
  // bool linked = false;
  // @observable
  // User? user;
  // @observable
  // bool codeSent = false;
  // @observable
  // Customer? sellerBD;
  // @observable
  // OverlayEntry? overlayEntry;
  // @observable
  // bool canBack = true;
  @observable
  ConfirmationResult? resultConfirm;

  // @action
  // bool getCanBack() => canBack;

  // @action
  // String getUserVerifyId() => userVerifyId!;

  // @action
  // setCodeSent(bool _valc) => codeSent = _valc;
  // @action
  // setLinked(bool _vald) => linked = _vald;
  // @action
  // setUser(User? value) {
  //   user = value;
  //   status = user == null ? AuthStatus.signed_out : AuthStatus.signed_in;
  // }

  // _AuthStoreBase(this.seller);

  @action
  Future signinWithGoogle() async {
    await _authService.handleGoogleSignin();
  }

  // @action
  // Future linkAccountGoogle() async {
  //   await _authService.handleLinkAccountGoogle(user!);
  // }

  // @action
  // Future getUser() async {
  //   user = await _authService.handleGetUser();
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .get()
  //       .then((value) {
  //     // //print'dentro do then  ${value.data['firstName']}');
  //     sellerBD = Customer.fromDoc(value);
  //     // user = ;
  //     // //print'depois do fromDoc  $user');

  //     return user;
  //   });
  // }

  // @action
  // Future signup(Customer customer) async {
  //   customer = await _authService.handleSignup(customer);
  // }

  @action
  Future signout() async {
    // setUser(null);
    return _authService.handleSetSignout();
  }

  @action
  Future sentSMS(String userPhone) async {
    return _authService.verifyNumber(userPhone);
  }

  @action
  Future verifyNumber(String userPhone, BuildContext context,
      {required Function removeLoad, required Function timerInit}) async {
    if(kIsWeb){
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        resultConfirm = await _auth.signInWithPhoneNumber(userPhone);

        final el =
            html.window.document.getElementById('__ff-recaptcha-container');
        if (el != null) {
          el.style.visibility = 'hidden';
        }

        print("resultCOnfirm: ${resultConfirm!.verificationId}");
        userVerificationId = resultConfirm!.verificationId;

        timerInit();
        removeLoad();
        await Modular.to.pushNamed('/verify', arguments: userPhone);
      } on FirebaseAuthException catch (e) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(e.message);
        print(e.code);
        removeLoad();

        showToast(e.code);
      }
    } else {
      await _auth.verifyPhoneNumber(
      phoneNumber: userPhone,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        OverlayEntry loadOverlay =
            OverlayEntry(builder: (context) => LoadCircularOverlay());
        Overlay.of(context)!.insert(loadOverlay);
        try {
          print('authCredential: =================$authCredential');

          final User _user =
              (await _auth.signInWithCredential(authCredential)).user!;

          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection("customers")
              .doc(_user.uid)
              .get();

          if (userDoc.exists) {
            print('%%%%%%%% signinPhone _user.exists == true  %%%%%%%%');
            String? tokenString = await FirebaseMessaging.instance.getToken();
            print('tokenId: $tokenString');

            Modular.to.pushReplacementNamed('/main');
          } else {
            print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');
            await _authService.handleSignup();
            Modular.to.pushReplacementNamed('/on-boarding');
          }
        } catch (e) {
          if (e.toString() ==
              '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
            Fluttertoast.showToast(
                msg: "Sessão expirada!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }

        loadOverlay.remove();
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(authException.message);
        print(authException.code);
        removeLoad();

        showToast(authException.code);
      },
      codeSent: (String verificationId, int? forceResendingToken) async {
        print("verificationId: $verificationId");
        userVerificationId = verificationId;
        userForceResendingToken = forceResendingToken;

        timerInit();
        removeLoad();
        await Modular.to.pushNamed('/verify', arguments: userPhone);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("codeAutoRetrievalTimeout ID: $verificationId");
      },
    );
  }    
}

  @action
  handleSmsSignin(String smsCode) async {
    // print('%%%%%%%% handleSmsSignin %%%%%%%%');
    print('credential: =================$smsCode');
    if(kIsWeb){
      try {
        UserCredential userCredential = await resultConfirm!.confirm(smsCode);
        User _user= userCredential.user!;
        DocumentSnapshot _userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_user.uid)
          .get();

        if (_userDoc.exists) {
          
          Modular.to.pushReplacementNamed('/main/');
        } else {
          await _authService.handleSignup();

          Modular.to.pushReplacementNamed('/on-boarding');
        }
      } on FirebaseAuthException catch (e) {
        print('Failed with error code: ${e.code}');
        switch (e.code) {
          case 'invalid-verification-code':
            return showToast("Código inválido");

          case "too-many-requests":
            return showToast("Número bloqueado por muitas tentativas de login");

          case "session-expired":
            return showToast("Sessão expirada!");

          default:
            print('Case of ${e.code} not defined');
        }
      }
    } else {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: userVerificationId!, smsCode: smsCode);

      try {
        final User _user = (await _auth.signInWithCredential(credential)).user!;
        print('user: =================$_user');
        DocumentSnapshot _userDoc = await FirebaseFirestore.instance
            .collection('customers')
            .doc(_user.uid)
            .get();

        if (_userDoc.exists) {

          String? tokenString = await FirebaseMessaging.instance.getToken();
          print('tokenId: $tokenString');

          await _userDoc.reference.update({
            'token_id': [tokenString]
          });
          
          Modular.to.pushReplacementNamed('/main');
        } else {
          await _authService.handleSignup();

          Modular.to.pushReplacementNamed('/on-boarding');
        }
      } on FirebaseAuthException catch (e) {
        print('%%%%%%%%% error: ${e.code} %%%%%%%%%%%');
        if (e.code == 'invalid-verification-code') {
          showToast("Código inválido!");
        }
        if (e.code =='session-expired') {
          showToast("Sessão expirada!");
        }
        if (e.code =='too-many-requests') {
          showToast("Número bloqueado por muitas tentativas de login");
        }
      }
    }
  }

  @action
  Future<Map> siginEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? _user = userCredential.user;

      print('siginEmail $_user');

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("customers")
          .doc(_user!.uid)
          .get();

      if (userDoc.exists) {
        print('%%%%%%%% signinEmail _user.exists == true  %%%%%%%%');
        String? tokenString = await FirebaseMessaging.instance.getToken();
        print('tokenId: $tokenString');

        await userDoc.reference.update({
          'token_id': [tokenString]
        });

        Modular.to.pushNamed('/address', arguments: true);
      } else {
        print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');

        await _authService.handleSignup();

        Modular.to.pushNamed('/address', arguments: true);
      }

      return {
        'code': 'success',
        'user': _user,
      };
    } on FirebaseAuthException catch (error) {
      print('ERROR');
      print(error.code);
      return {
        'code': error.code,
        'user': null,
      };
    }
  }

  @action
  createUserWithEmail(String userEmail, String userPassword) async {
    print('createUserWithEmail');
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      User? _user = userCredential.user;

      print('siginEmail $_user');

      if (_user != null) {
        print('%%%%%%%% signinPhone _user.exists == false  %%%%%%%%');

        await _authService.handleSignup();

        Modular.to.pushNamed('/address', arguments: true);

        return {
          'code': 'success',
          'user': _user,
        };
      }
    } on FirebaseAuthException catch (error) {
      print('ERROR2');
      print(error.code);
      return {
        'code': error.code,
        'user': null,
      };
    }
  }

  @action
  Future<void> resendingSMS(String userPhone,
      {required Function removeLoadOverlay, required Function timerInit}) async{
    if(kIsWeb) {
      try {
        final FirebaseAuth _auth = FirebaseAuth.instance;

        resultConfirm = await _auth.signInWithPhoneNumber(userPhone);

        final el =
            html.window.document.getElementById('__ff-recaptcha-container');
        if (el != null) {
          el.style.visibility = 'hidden';
        }

        print("resultCOnfirm: ${resultConfirm!.verificationId}");
        userVerificationId = resultConfirm!.verificationId;
        timerInit();
        removeLoadOverlay();
        // timerInit();
        // removeLoad();
        // await Modular.to.pushNamed('/verify', arguments: userPhone);
      } on FirebaseAuthException catch (e) {
        print(
            '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
        print(e.message);
        print(e.code);
        // removeLoad();
        showToast(e.code);
      }
    } else {
      _auth.verifyPhoneNumber(
        forceResendingToken: userForceResendingToken,
        phoneNumber: userPhone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          try {
            final User _user =
                (await _auth.signInWithCredential(authCredential)).user!;

            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection("customers")
                .doc(_user.uid)
                .get();

            if (userDoc.exists) {
              String? tokenString = await FirebaseMessaging.instance.getToken();
              print('tokenId: $tokenString');

              await userDoc.reference.update({
                'token_id': [tokenString]
              });

              Modular.to.pushReplacementNamed('/main');
            } else {
              await _authService.handleSignup();
              Modular.to.pushReplacementNamed('/on-boarding');
            }
          } catch (e) {
            if (e.toString() ==
                '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
              Fluttertoast.showToast(
                  msg: "Sessão expirada!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
          removeLoadOverlay();
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(
              '%%%%%%%%%%%%%%%%%%%%% verification failed %%%%%%%%%%%%%%%%%%%%%');
          print(authException.message);
          print(authException.code);
          showToast(authException.code);
          removeLoadOverlay();
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          print("verificationId: $verificationId");
          userVerificationId = verificationId;
          userForceResendingToken = forceResendingToken;
          timerInit();
          removeLoadOverlay();
        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          print("codeAutoRetrievalTimeout ID: $verificationId");
        },
      );

    }    
  }
}

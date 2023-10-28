import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'widget/confirm_code.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store implements Disposable {
  _ProfileStoreBase() {
    if (FirebaseAuth.instance.currentUser != null) {
      User _user = FirebaseAuth.instance.currentUser!;
      profileSubs = FirebaseFirestore.instance
          .collection("customers")
          .doc(_user.uid)
          .snapshots()
          .listen((doc) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        map['linked_to_cnpj'] = map['linked_to_cnpj'] ?? false;
        map['savings_account'] = map['savings_account'] ?? false;
        profileEdit = map.asObservable();
      });
    }
  }

  @override
  void dispose() {
    if (profileSubs != null) profileSubs!.cancel();
    profileEdit.clear();
  }

  final MainStore mainStore = Modular.get();

  late OverlayEntry loadOverlay;

  @observable
  ObservableMap profileEdit = {}.asObservable();
  @observable
  bool birthdayValidate = false;
  @observable
  bool genderValidate = false;
  @observable
  bool avatarValidate = false;
  @observable
  bool canBack = true;
  @observable
  String userVerificationId = '';
  @observable
  int forceResendingToken = 0;
  @observable
  OverlayEntry? confirmCodeOverlay;
  @observable
  StreamSubscription? profileSubs;
  @observable
  bool loadCircularCode = false;
  @observable
  String? code;
  @observable
  int? timerSeconds;
  @observable
  Timer? timerResendeCode;
  @observable
  Uint8List? bytesAvatar;
  @observable
  String? avatarFileName;

  @action
  Future<void> activeCoupon(String couponId) async {
    final User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot activedCoupons = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('active_coupons')
        .where('actived', isEqualTo: true)
        .where('used', isEqualTo: false)
        .where('status', isEqualTo: "VALID")
        .get();

    if (activedCoupons.docs.isNotEmpty) {
      activedCoupons.docs.first.reference.update({
        "actived": false,
      });
    }

    FirebaseFirestore.instance
        .collection('customers')
        .doc(_user.uid)
        .collection('active_coupons')
        .doc(couponId)
        .update({"actived": true});
  }

  @action
  Future<void> clearNewNotifications() async {
    print('clearNewNotifications');
    User? _user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .update({
      "new_notifications": 0,
    });
    // setProfileEditFromDoc();
  }

  @action
  Future<void> share() async {
    User? _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .get();
    await FlutterShare.share(
        title: 'Se liga nesse aplicativo Mercado Expresso',
        text:
            'Use o meu código promocional ao entrar no aplicativo, meu código: ${userDoc['user_promotional_code']}',
        linkUrl: 'https://mercadoexpresso.com.br/',
        chooserTitle: 'Compartilhar usando');
  }

  @action
  Future<void> pickAvatar() async {
    XFile? responseFile = await pickImage();
    print('response: $responseFile');
    if (responseFile != null) {
      avatarFileName = responseFile.name;
      bytesAvatar = await responseFile.readAsBytes();
      avatarValidate = false;
    }
  }

  @action
  bool getValidate() {
    if (profileEdit['birthday'] == null) {
      birthdayValidate = true;
    } else {
      birthdayValidate = false;
    }

    if (profileEdit['gender'] == null || profileEdit['gender'] == '') {
      genderValidate = true;
    } else {
      genderValidate = false;
    }

    if (profileEdit['avatar'] == null && bytesAvatar == null) {
      avatarValidate = true;
    } else {
      avatarValidate = false;
    }

    return !birthdayValidate && !genderValidate && !avatarValidate;
  }

  // @action
  // setProfileEditFromDoc() async {
  //   User _user = FirebaseAuth.instance.currentUser!;

  //   DocumentSnapshot _ds = await FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(_user.uid)
  //       .get();
  //   Map<String, dynamic> map = _ds.data() as Map<String, dynamic>;
  //   map['linked_to_cnpj'] = map['linked_to_cnpj'] ?? false;
  //   map['savings_account'] = map['savings_account'] ?? false;
  //   ObservableMap<String, dynamic> customerMap = map.asObservable();
  //   profileEdit = customerMap;
  // }

  @action
  setBirthday(context, void Function() onConfirm) async {
    pickDate(context, onConfirm: (date) {
      print("Date: $date");
      if (date != null && date != profileEdit['birthday']) {
        profileEdit['birthday'] = Timestamp.fromDate(date);
        birthdayValidate = false;
      }
      onConfirm();
    });
  }

  // Future<void> setTokenLogout() async {
  //   User _user = FirebaseAuth.instance.currentUser!;
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   print('user token: $token');
  //   DocumentSnapshot _userDoc = await FirebaseFirestore.instance
  //       .collection('customers')
  //       .doc(_user.uid)
  //       .get();

  //   List tokens = _userDoc['token_id'];
  //   print('tokens length: ${tokens.length}');

  //   for (var i = 0; i < tokens.length; i++) {
  //     if (tokens[i] == token) {
  //       print('has $token');
  //       tokens.removeAt(i);
  //       print('tokens: $tokens');
  //     }
  //   }
  //   print('tokens2: $tokens');
  //   _userDoc.reference.update({'token_id': tokens});
  // }

  @action
  Future<void> downloadImage() async {
    User _user = FirebaseAuth.instance.currentUser!;
    if (bytesAvatar != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('customers/${_user.uid}/avatar/$avatarFileName');

      UploadTask uploadTask = firebaseStorageRef.putData(bytesAvatar!);

      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      profileEdit['avatar'] = downloadURL;
      bytesAvatar = null;
      avatarFileName = null;
    }
  }

  @action
  Future<Map> saveProfile(context) async {
    User _user = FirebaseAuth.instance.currentUser!;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    if (!profileEdit['phone'].contains('+')) {
      profileEdit['phone'] = '+' + profileEdit['phone'];
    }

    Map<String, dynamic> _profileMap = profileEdit.cast();
    print("_profileMap: $_profileMap");

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user.uid)
        .get();

    String? userEmail = userDoc['email'];
    String? userPhone = userDoc['phone'];

    if (userEmail != _profileMap['email'] ||
        userPhone != _profileMap['phone']) {
      return {
        'status': 'need-update',
        'update_email': userEmail != _profileMap['email'],
        'update_phone': userPhone != _profileMap['phone'],
      };
    } else {
      await downloadImage();
      await userDoc.reference.update(_profileMap);
      canBack = true;

      loadOverlay.remove();
      Modular.to.pop();
      return {
        'status': 'success',
      };
    }
  }

  @action
  updateAuthUser({
    required BuildContext context,
    required bool editEmail,
    required bool editPhone,
  }) async {
    Map<String, dynamic> _profileMap = profileEdit.cast();

    print(
        'updateAuthUser email: ${_profileMap['email']} - phone: ${_profileMap['phone']}');

    if (editPhone) {
      try {
        loadOverlay.remove();

        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: _profileMap['phone'],
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
            loadCircularCode = true;
            String result = await updateUserPhone(phoneAuthCredential);
            if (result == 'success') {
              if (editEmail) {
                await updateUserEmail(
                    _profileMap['email'], context, _profileMap['phone']);
              } else {
                await editUser();
              }
            }
            loadCircularCode = false;
          },
          verificationFailed: (FirebaseAuthException execption) {
            print(
                'xxxxxxxxxxxxxx verificationFailed: ${execption.code} xxxxxxxxxxx');
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            print(
                'xxxxxxxxxxxxxx codeSent $verificationId - $forceResendingToken xxxxxxxxxxxxxxx');
            userVerificationId = verificationId;
            forceResendingToken = forceResendingToken;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
          },
        );

        confirmCodeOverlay = OverlayEntry(
          builder: (context) => ConfirmCode(
            numberPhone: _profileMap['phone'],
            resend: () {
              const oneSec = const Duration(seconds: 1);

              timerSeconds = 60;

              timerResendeCode = Timer.periodic(oneSec, (timer) {
                if (timerSeconds == 0) {
                  timerSeconds = null;
                  timer.cancel();
                } else {
                  timerSeconds = timerSeconds! - 1;
                }
              });

              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: _profileMap['phone'],
                forceResendingToken: forceResendingToken,
                verificationCompleted:
                    (PhoneAuthCredential phoneAuthCredential) async {
                  print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
                  loadCircularCode = true;
                  String result = await updateUserPhone(phoneAuthCredential);
                  if (result == 'success') {
                    if (editEmail) {
                      await updateUserEmail(
                          _profileMap['email'], context, _profileMap['phone']);
                    } else {
                      await editUser();
                    }
                  }
                  loadCircularCode = false;
                },
                verificationFailed: (FirebaseAuthException execption) {
                  print(
                      'xxxxxxxxxxxxxx verificationFailed: ${execption.code} xxxxxxxxxxx');
                  showToast(
                      'Espere alguns instantes para poder solicitar outro SMS.');
                },
                codeSent: (String verificationId, int? forceResendingToken) {
                  print(
                      'xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
                },
              );
            },
            cancel: () async {
              confirmCodeOverlay!.remove();
            },
            confirm: () async {
              try {
                loadCircularCode = true;

                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: userVerificationId, smsCode: code!);
                String result = await updateUserPhone(credential);
                if (result == 'success') {
                  if (editEmail) {
                    await updateUserEmail(
                        _profileMap['email'], context, _profileMap['phone']);
                  } else {
                    await editUser();
                  }
                }
                loadCircularCode = false;
              } catch (e) {
                print('%%%%%%%%%%% error: $e %%%%%%%%%%%');
                loadCircularCode = false;
                showToast('Código inválido', Colors.red);
              }
            },
          ),
        );

        Overlay.of(context)!.insert(confirmCodeOverlay!);
      } on FirebaseAuthException catch (error) {
        print('ERROR');
        print(error.code);
        showToast('OPS... algo deu errado', Colors.red);
      }
    } else {
      if (editEmail) {
        await updateUserEmail(
            _profileMap['email'], context, _profileMap['phone']);
      }
    }
  }

  Future<String> updateUserPhone(
      PhoneAuthCredential? phoneAuthCredential) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? currentUser = _auth.currentUser;

    try {
      await currentUser!.updatePhoneNumber(phoneAuthCredential!);
      confirmCodeOverlay!.remove();
      return 'success';
    } on FirebaseAuthException catch (error) {
      print('ERROR updateUserPhone');
      print(error.code);

      if (error.code == 'invalid-verification-code') {
        showToast('Código inválido', Colors.red);
      }

      if (error.code == 'credential-already-in-use') {
        showToast('Este número de telefone já está sendo usado', Colors.red);
      }

      if (error.code == 'invalid-verification-id') {
        showToast('OPS... algo deu errado', Colors.red);
      }

      return 'failed';
    }
  }

  Future<void> updateUserEmail(
    String email,
    BuildContext context,
    String phone,
  ) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? currentUser = _auth.currentUser;
    try {
      await currentUser!.updateEmail(email);
      await currentUser.reload();
      await currentUser.sendEmailVerification();
      await editUser();
      showToast(
          'Um e-mail de verificação foi enviado para a sua caixa de entrada');
      if (confirmCodeOverlay != null && confirmCodeOverlay!.mounted) {
        confirmCodeOverlay!.remove();
      }

      if (loadOverlay.mounted) {
        loadOverlay.remove();
      }
      loadCircularCode = false;
    } on FirebaseAuthException catch (error) {
      print('ERROR');
      print(error.code);

      if (error.code == 'invalid-email') {
        showToast('E-mail inválido');
      }

      if (error.code == 'email-already-in-use') {
        showToast('Esse e-mail já está em uso');
      }

      if (error.code == 'requires-recent-login') {
        if (loadOverlay.mounted) {
          loadOverlay.remove();
        }
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
            loadCircularCode = true;
            await _auth.signInWithCredential(phoneAuthCredential);
            await currentUser!.updateEmail(email);
            await currentUser.reload();
            await currentUser.sendEmailVerification();
            await editUser();
            if (confirmCodeOverlay!.mounted) {
              confirmCodeOverlay!.remove();
            }
            loadCircularCode = false;
          },
          verificationFailed: (FirebaseAuthException execption) {
            print(
                'xxxxxxxxxxxxxx verificationFailed: ${execption.code} xxxxxxxxxxx');
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            print(
                'xxxxxxxxxxxxxx codeSent $verificationId - $forceResendingToken xxxxxxxxxxxxxxx');
            userVerificationId = verificationId;
            forceResendingToken = forceResendingToken;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
          },
        );

        confirmCodeOverlay = OverlayEntry(
          builder: (context) => ConfirmCode(
            numberPhone: phone,
            resend: () {
              const oneSec = const Duration(seconds: 1);

              timerSeconds = 60;

              timerResendeCode = Timer.periodic(oneSec, (timer) {
                if (timerSeconds == 0) {
                  timerSeconds = null;
                  timer.cancel();
                } else {
                  timerSeconds = timerSeconds! - 1;
                }
              });

              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: phone,
                forceResendingToken: forceResendingToken,
                verificationCompleted:
                    (PhoneAuthCredential phoneAuthCredential) async {
                  print('xxxxxxxxxxxxx verificationCompleted xxxxxxxxxxxx');
                  loadCircularCode = true;
                  await currentUser!.updateEmail(email);
                  await currentUser.reload();
                  await currentUser.sendEmailVerification();
                  await editUser();
                  if (confirmCodeOverlay!.mounted) {
                    confirmCodeOverlay!.remove();
                  }
                  loadCircularCode = false;
                },
                verificationFailed: (FirebaseAuthException execption) {
                  print(
                      'xxxxxxxxxxxxxx verificationFailed: ${execption.code} xxxxxxxxxxx');
                  showToast(
                      'Espere alguns instantes para poder solicitar outro SMS.');
                },
                codeSent: (String verificationId, int? forceResendingToken) {
                  print(
                      'xxxxxxxxxxxxxx codeSent $verificationId xxxxxxxxxxxxxxx');
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print('xxxxxxxxx codeAutoRetrievalTimeout xxxxxxxxxx');
                },
              );
            },
            cancel: () async {
              confirmCodeOverlay!.remove();
            },
            confirm: () async {
              try {
                loadCircularCode = true;

                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: userVerificationId, smsCode: code!);

                await _auth.signInWithCredential(credential);

                await currentUser!.updateEmail(email);
                await currentUser.reload();
                await currentUser.sendEmailVerification();
                await editUser();
                if (confirmCodeOverlay!.mounted) {
                  confirmCodeOverlay!.remove();
                }
                loadCircularCode = false;
              } on FirebaseAuthException catch (e) {
                print('%%%%%%%%%%% error: %%%%%%%%%%%');
                print(e.code);
                loadCircularCode = false;
                showToast('Código inválido', Colors.red);
              }
            },
          ),
        );

        Overlay.of(context)!.insert(confirmCodeOverlay!);
      }
    }
  }

  Future<void> editUser() async {
    User _user = FirebaseAuth.instance.currentUser!;
    await downloadImage();

    Map<String, dynamic> _profileMap = profileEdit.cast();

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user.uid)
        .get();

    await userDoc.reference.update(_profileMap);
    Modular.to.pop();
  }

  @action
  Future<List<List>> getNotifications() async {
    List oldNotifications = [];
    List newNotifications = [];
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot allNotifications = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('notifications')
        .orderBy('sended_at', descending: true)
        .get();

    for (var i = 0; i < allNotifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = allNotifications.docs[i];
      if (notificationDoc['viewed']) {
        oldNotifications.add(notificationDoc);
      } else {
        newNotifications.add(notificationDoc);
      }
    }

    return [
      newNotifications,
      oldNotifications,
    ];
  }

  @action
  String getTime(Timestamp sendedAt) {
    // DateTime dateTime = sendedAt.toDate().toUtc();
    DateTime dateTime = sendedAt.toDate();
    DateTime now = DateTime.now();
    // print('difference: ${now.difference(dateTime).inMinutes}');
    // print('difference: ${now.difference(dateTime).inHours}');
    // print('difference: ${now.difference(dateTime).inDays}');
    if (now.difference(dateTime).inMinutes < 60) {
      return "${now.difference(dateTime).inMinutes} min";
    }

    if (now.difference(dateTime).inHours < 24) {
      return "${now.difference(dateTime).inHours} h";
    }

    if (now.difference(dateTime).inDays < 2) {
      return "${now.difference(dateTime).inDays} dia";
    }

    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    // String hour = dateTime.hour.toString().padLeft(2, '0');
    // String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$day/$month/$year";
    // return "$day/$month/$year $hour:$minute";
  }

  @action
  Future<void> visualizedAllNotifications() async {
    User? _user = FirebaseAuth.instance.currentUser;

    QuerySnapshot allNotifications = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('notifications')
        .where('viewed', isEqualTo: false)
        .get();

    for (var i = 0; i < allNotifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = allNotifications.docs[i];
      await notificationDoc.reference.update({"viewed": true});
    }
  }

  @action
  changeNotificationEnabled(bool change) async {
    print('changeNotificationEnabled $change');
    profileEdit['notification_enabled'] = change;
    FirebaseFirestore.instance
        .collection('customers')
        .doc(profileEdit['id'])
        .update({'notification_enabled': change});
  }
}

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivery_customer/app/core/models/card_model.dart';
import 'package:delivery_customer/app/core/models/transaction_model.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'widgets/email_verification_dialog.dart';
part 'payment_store.g.dart';

class PaymentStore = _PaymentStoreBase with _$PaymentStore;

abstract class _PaymentStoreBase with Store {
  @observable
  bool canBack = true;
  @observable
  ObservableList cards = [{}].asObservable();
  @observable
  int randomColor1 = (Random().nextDouble() * 0xffffffff).toInt() << 0,
      randomColor2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  @observable
  ObservableMap cardMap = ObservableMap();
  @observable
  OverlayEntry? emailVerificationOverlay;
  @observable
  bool loadCircularEmailVerification = false;
  @observable
  ObservableList<CardModel>? cardList;
  @observable
  ObservableList<TransactionModel>? transactionList;
  @observable
  OverlayEntry? confirmDeleteOverlay;
  @observable
  OverlayEntry? noHasEmailOverlay;

  @action
  void getColors() {
    randomColor1 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
    randomColor2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  }

  @action
  removeCard(BuildContext context, String cardUid) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _currentUser = _auth.currentUser!;
    confirmDeleteOverlay = OverlayEntry(
      builder: (context) => ConfirmPopup(
          height: wXD(160, context),
          text: 'Tem certeza que deseja excluir este cartão?',
          onCancel: () => confirmDeleteOverlay!.remove(),
          onConfirm: () async {
            FirebaseFunctions functions = FirebaseFunctions.instance;

            HttpsCallable removeCardInStripeFunction =
                functions.httpsCallable('removeCardInStripe');

            HttpsCallableResult response =
                await removeCardInStripeFunction.call({
              'cardUid': cardUid,
              'userCollection': 'customers',
              'uid': _currentUser.uid,
            });

            print('response: ${response.data}');

            if (response.data == 'success') {
              confirmDeleteOverlay!.remove();
              Modular.to.pop();
            } else {
              confirmDeleteOverlay!.remove();
              showToast('Erro ao remover o cartão', Colors.red);
            }
          }),
    );

    Overlay.of(context)?.insert(confirmDeleteOverlay!);
  }

  @action
  addCard(BuildContext context) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);
    canBack = false;

    FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser!;

    bool hasError = await emailVerification(context);
    bool success = false;

    cardMap['colors'] = [randomColor1, randomColor2];

    if (!hasError) {
      print('cardMap: $cardMap');
      FirebaseFunctions functions = FirebaseFunctions.instance;

      HttpsCallable createCardInStripe =
          functions.httpsCallable("createCardInStripe");

      final customerDoc = await FirebaseFirestore.instance
          .collection("customers")
          .doc(_user.uid)
          .get();

      if (customerDoc["customer_id"] == null) {
        final customerCreate = functions.httpsCallable("customerCreate");
        await customerCreate.call({
          'userUid': _user.uid,
        });
      }

      try {
        HttpsCallableResult response = await createCardInStripe.call({
          'uid': _user.uid,
          'userCollection': 'customers',
          'card': cardMap,
        });

        print('response createCardInStripe: ${response.data}');

        switch (response.data) {
          case 'incorrect_number':
            showToast('Número de cartão inválido', Colors.red);
            break;

          case 'card_declined':
            showToast('Cartão recusado', Colors.red);
            break;

          case 'expired_card':
            showToast('Cartão expirado', Colors.red);
            break;

          case 'invalid_expiry_year':
            showToast('Data de vencimento inválida', Colors.red);
            break;

          case 'incorrect_cvc':
            showToast('Código de segurança inválido', Colors.red);
            break;

          case 'processing_error':
            showToast('Erro ao criar o cartão, contate o suporte', Colors.red);
            break;

          case 'success':
            success = true;
            break;

          default:
            showToast('OPS... algo deu errado, contate o suporte', Colors.red);
            print("responseData: ${response.data}");
            break;
        }
      } catch (e) {
        print("Error on function: $e");
      }
    }
    canBack = true;

    loadOverlay.remove();
    if (success) {
      Modular.to.pop();
    }
  }

  Future<bool> emailVerification(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = _auth.currentUser!;
    await _user.reload();
    bool _hasError = false;

    _hasError = !_user.emailVerified;

    print('_user.emailVerified_user.emailVerified ${_user.emailVerified}');

    if (_hasError) {
      DocumentSnapshot _userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_user.uid)
          .get();
      if (_userDoc['email'] == null) {
        noHasEmailOverlay = OverlayEntry(
          builder: (context) => ConfirmPopup(
            text: "Você precisa de um e-mail, deseja adicionar?",
            onConfirm: () async {
              Modular.to.pushNamed('/profile/edit-profile');
              noHasEmailOverlay!.remove();
              noHasEmailOverlay = null;
            },
            onCancel: () => noHasEmailOverlay!.remove(),
          ),
        );
        Overlay.of(context)!.insert(noHasEmailOverlay!);
      } else {
        emailVerificationOverlay = OverlayEntry(
          builder: (context) => EmailVerificationDialog(
            email: _user.email,
            onCancel: () {
              print('on tap 1');
              emailVerificationOverlay!.remove();
            },
            title: 'Você não possui um e-mail válido ainda.',
          ),
        );

        Overlay.of(context)!.insert(emailVerificationOverlay!);
      }
    }

    return _hasError;
  }

  Future<void> pushProfile() async {
    loadCircularEmailVerification = true;

    Modular.to.pushNamed('/profile/edit-profile');

    emailVerificationOverlay!.remove();

    loadCircularEmailVerification = false;
  }

  Future<void> resendVerificationEmail() async {
    loadCircularEmailVerification = true;

    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User _user = _auth.currentUser!;
      await _user.reload();

      if (!_user.emailVerified) {
        await _user.sendEmailVerification();

        print('Link mágico enviado para a sua caixa de entrada');

        Fluttertoast.showToast(
            msg: 'Link mágico enviado para a sua caixa de entrada');
      } else {
        Fluttertoast.showToast(msg: 'E-mail já validado!');
        emailVerificationOverlay!.remove();
      }
    } on FirebaseAuthException catch (error) {
      print('error');
      print(error.code);

      if (error.code == 'too-many-requests') {
        Fluttertoast.showToast(
          msg: 'Espere alguns minutos para poder enviar outro link!',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }

    loadCircularEmailVerification = false;
  }

  @action
  Future<void> cardsListMount(
      QuerySnapshot<Map<String, dynamic>>? snapshotCards) async {
    print('cardsListMount ${snapshotCards!.docs.length}');
    if (snapshotCards.docs.isEmpty) {
      cardList = ObservableList<CardModel>();
    } else {
      cardList = ObservableList<CardModel>();
      snapshotCards.docs.forEach((cardDoc) {
        CardModel cardModel = CardModel.fromDoc(cardDoc);
        cardList!.add(cardModel);
      });
    }
  }

  @action
  transactionsListMount(
      QuerySnapshot<Map<String, dynamic>>? snapshotTransactions) {
    print('transactionsListMount: ${snapshotTransactions!.docs.length}');
    if (snapshotTransactions.docs.isEmpty) {
      transactionList = ObservableList<TransactionModel>();
    } else {
      transactionList = ObservableList<TransactionModel>();

      snapshotTransactions.docs.forEach((transactionDoc) {
        TransactionModel transactionModel =
          TransactionModel.fromDoc(transactionDoc);

        transactionList!.add(transactionModel);
      });
    }
  }

  @action
  Future<void> alteredMainCard(bool value, String cardId) async{
    User user = FirebaseAuth.instance.currentUser!;
    FirebaseFunctions functions = FirebaseFunctions.instance;

    HttpsCallable alteredMainCard = functions.httpsCallable("alteredMainCard");
    try {
      print("try");
      HttpsCallableResult<String> response = await alteredMainCard.call({
        'uid': user.uid,
        "value": value,
        "cardId": cardId,
        "userCollection": "customers",
      });
      print('response: ${response.data}');
      
    } catch (e) {
      print(e);      
    }

  }

  @action
  String getFormatedDueDate(String dueDate) {
    return dueDate.substring(0, 2) + '/' + dueDate.substring(2, 4);
  }
}

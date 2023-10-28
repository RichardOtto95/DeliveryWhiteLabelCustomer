import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/confirm_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

import '../../shared/widgets/load_circular_overlay.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStoreBase with _$HomeStore;

abstract class _HomeStoreBase with Store {
  @observable
  StreamSubscription? _userStreamSubscription;
  @observable
  String? categorySelected;
  @observable
  String promotionalCode = '';
  @observable
  bool canBack = true;

  void wasInvitedListen() async {
    User? _user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .get();

    if (userDoc['was_invited'] == null) {
      Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
          .collection('customers')
          .doc(_user.uid)
          .snapshots();

      _userStreamSubscription = _userStream.listen((DocumentSnapshot _userDoc) {
        print('_userStreamSubscription: ${_userDoc['was_invited']}');
        if (_userDoc.get('was_invited') != null) {
          cancelSubscription();
        } else {
          Modular.to.pushNamed('/was-invited', arguments: () {
            cancelSubscription();
          });
        }
      });
    }
  }

  void cancelSubscription() {
    print('cancelSubscription');
    _userStreamSubscription!.cancel();
  }

  void setWasInvited(bool accept, BuildContext context) async {
    print('setWasInvited: $accept');

    late OverlayEntry confirmOverlay;

    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    User? _user = FirebaseAuth.instance.currentUser;

    if (accept) {
      Overlay.of(context)!.insert(loadOverlay);
      canBack = false;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_user!.uid)
          .get();

      QuerySnapshot userPromotionalCodeQuery = await FirebaseFirestore.instance
          .collection('customers')
          .where('user_promotional_code', isEqualTo: promotionalCode)
          .get();

      if (userPromotionalCodeQuery.docs.isNotEmpty) {
        DocumentSnapshot userPromotionalCodeDoc =
            userPromotionalCodeQuery.docs.first;

        userDoc.reference.update({
          'was_invited': true,
        });

        Map<String, dynamic> object = {
          'created_at': FieldValue.serverTimestamp(),
          'code': promotionalCode,
          'used': false,
          'user_id': userPromotionalCodeDoc.id,
          'type': "FRIEND_INVITE",
          // 'percent_off': 0.1,
          'percent_off': null,
          // 'discount': null,
          'discount': 5,
          'actived': true,
          'status': 'VALID',
          'guest_id': userDoc.id,
          "text": "Convite de seu amigo ${userPromotionalCodeDoc['username']}",
          "value_minimum": null,
        };

        DocumentReference couponRef =
            await userDoc.reference.collection('active_coupons').add(object);

        FirebaseFirestore.instance
            .collection('coupons')
            .doc(couponRef.id)
            .set(object);

        await userPromotionalCodeDoc.reference
            .collection('friends_invited')
            .doc(userDoc.id)
            .set({
          'created_at': FieldValue.serverTimestamp(),
          'user_id': userDoc.id,
          'recuperatedd': false,
          'value': 5,
        });
        canBack = true;
        loadOverlay.remove();
        Modular.to.pop();
      } else {
        print('Código não encontrado');
        Fluttertoast.showToast(
            msg: "Código não encontrado",
            backgroundColor: Colors.red,
            textColor: Colors.white);
        loadOverlay.remove();
      }
    } else {
      confirmOverlay = OverlayEntry(
        builder: (context) => ConfirmPopup(
          height: wXD(165, context),
          text:
              "Este código só poderá ser utlizado desta vez!\nTem certeza que deseja sair?",
          onConfirm: () async {
            Overlay.of(context)!.insert(loadOverlay);
            DocumentReference userDoc = FirebaseFirestore.instance
                .collection('customers')
                .doc(_user!.uid);

            await userDoc.update({
              "was_invited": false,
            });

            canBack = true;
            canBack = true;
            loadOverlay.remove();
            confirmOverlay.remove();
            Modular.to.pop();
          },
          onCancel: () async => confirmOverlay.remove(),
        ),
      );
      Overlay.of(context)!.insert(confirmOverlay);
    }
  }

  // @action
  // Future<void> getCategoryItems(String category) async {
  // if (categorySelected == category) {
  //   categorySelected = "";
  //   categoryItems = null;
  //   return;
  // }

  // categorySelected = category;

  // categoryItems = (await FirebaseFirestore.instance
  //         .collection("ads")
  //         .where("category", isEqualTo: category)
  //         .get())
  //     .docs;
  // }
}

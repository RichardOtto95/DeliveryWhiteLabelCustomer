import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/cart_model.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/customer_model.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store implements Disposable {
  final AuthStore authStore = Modular.get();

  _MainStoreBase() {
    FirebaseAuth.instance.userChanges().listen((user) {
      print('user: $user');
      if (user == null) {
        customerSubscription?.cancel();
        customer = null;
      } else {
        customerSubscription = FirebaseFirestore.instance
            .collection("customers")
            .doc(user.uid)
            .snapshots()
            .listen((event) {
          print("Stream do customer: ${event.exists}");
          if (event.exists) {
            customer = Customer.fromDoc(event);
          }
        });
      }
    });
  }

  @observable
  PageController pageController = PageController(initialPage: 0);
  @observable
  int page = 0;
  @observable
  bool visibleNav = true;
  @observable
  String adsId = '';
  // @observable
  // ObservableList<String> cartObjId = ObservableList<String>();
  // @observable
  // ObservableList<CartModel> cartObj = ObservableList<CartModel>();
  @observable
  ObservableMap<String, CartModel> cart = <String, CartModel>{}.asObservable();
  @observable
  String cartSellerId = '';
  @observable
  OverlayEntry? loadOverlay;
  @observable
  OverlayEntry? globalOverlay;
    @observable
    StreamSubscription? customerSubscription;
    @observable
    Customer? customer;

    @action
  CrossAxisAlignment  getColumnAlignment(String alignment){
    switch (alignment) {
      case "left":
        return CrossAxisAlignment.start;

      case "center":
        return CrossAxisAlignment.center;

      case "right":
        return CrossAxisAlignment.end;

      default:
        return CrossAxisAlignment.start;
    }
  }

  @action
  MainAxisAlignment  getRowAlignment(String alignment){
    switch (alignment) {
      case "left":
        return MainAxisAlignment.start;

      case "center":
        return MainAxisAlignment.center;

      case "right":
        return MainAxisAlignment.end;

      default:
        return MainAxisAlignment.start;
    }
  }

  @action
  setAdsId(_adsId) => adsId = _adsId;
  @action
  setVisibleNav(_visibleNav) => visibleNav = _visibleNav;

  @override
  void dispose() {
    pageController.removeListener(() {});
    // pageController.dispose();
    // if (customerSubscription != null) customerSubscription!.cancel();
  }

  @action
  Future<void> viewProduct(String adsId) async {
    print('viewProduct: $adsId');
    setAdsId(adsId);
    Modular.to.pushNamed('/product');
  }

  @action
  Future<bool> addItemToCart(String adsId, Map additionalMap, BuildContext context) async {
    // print('additionalMap: $additionalMap');
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);

    DocumentSnapshot adsDoc =
        await FirebaseFirestore.instance.collection('ads').doc(adsId).get();
    if (cartSellerId != '') {
      if (cartSellerId != adsDoc['seller_id']) {
        cart.clear();
        cartSellerId = adsDoc['seller_id'];
      }
    } else {
      cartSellerId = adsDoc['seller_id'];
    }

    String message = '';

    // print('cart.isNotEmpty');
    if (cart.containsKey(adsId)) {
      message = 'Você já adicionou este produto ao carrinho';
    } else {
      num totalPrice = adsDoc['total_price'];
      additionalMap.forEach((id, additionalResponseMap) {

        switch (additionalResponseMap['additional_type']) {
          case "increment":
              totalPrice += additionalResponseMap['response_value'];
            break;

          case "radio-button":
              totalPrice += additionalResponseMap['response_value'];
            break;

          case "combo-box":
              totalPrice += additionalResponseMap['response_value'];
            break;

          case "check-box":
              Map checkedMap = additionalResponseMap['checked_map'];
              checkedMap.forEach((key, value) { 
                // print('value: $value');
                if(value['response'] == true){
                  totalPrice += value['value'];
                }
              });
            break;

          default:
            break;
        }
      });

      CartModel cartModel = CartModel(
        additionalMap: additionalMap,
        adsId: adsId,
        amount: 1,
        totalPrice: totalPrice,
        unitPrice: totalPrice,
        // rating: 0,
        // rated: false,
        sellerId: adsDoc["seller_id"],
      );

      cart.putIfAbsent(adsId, () => cartModel);
      message = 'Produto adicionado ao carrinho';
    }

    showToast(message);
    loadOverlay!.remove();
    return !cart.containsKey(adsId);
  }

  createCoupon() async {
    User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> qq = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('active_coupons')
        .get();
    DocumentSnapshot<Map<String, dynamic>> ds = qq.docs.first;
    DocumentReference dr = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user.uid)
        .collection('active_coupons')
        .add(ds.data()!);

    await dr.update({
      'id': dr.id,
      'type': 'PRICE_OFF',
      'discount': 10,
      'percent_off': 0,
      'user_id': null,
      'actived': false,
      'code': dr.id.substring(0, 8)
    });
  }

  @action
  setPage(_page) async {
    await pageController.animateToPage(
      _page,
      duration: Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
    page = _page;
  }

  @action
  Future<void> saveTokenToDatabase(String token) async {
    User? _user = FirebaseAuth.instance.currentUser;
    print('saveTokenToDatabase: $_user');

    if (_user != null) {
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(_user.uid)
          .update({
        'token_id': FieldValue.arrayUnion([token]),
      });
    }
  }

  @action
  Future<List<Map<String, dynamic>>> getRadiobuttonList(String additionalId, String sellerId) async{    
    // print('additionalId: $additionalId');
    // print('sellerId: $sellerId');
    List<Map<String, dynamic>> radiobuttonArray = [];
    QuerySnapshot radiobuttonList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("radiobutton")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    // print('@@@@@@@@@@@ radiobuttonList: ${radiobuttonList.docs.length}');

    for (DocumentSnapshot radiobuttonDoc in radiobuttonList.docs) {
      try {
        radiobuttonArray[radiobuttonDoc['index']] = {
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
        };
        
      } catch (e) {
        radiobuttonArray.add({
          "index": radiobuttonDoc['index'],
          "label": radiobuttonDoc['label'],
          "value": radiobuttonDoc['value'],
        });
      }
    }
    return radiobuttonArray;
  }

  @action
  Future<List<Map<String, dynamic>>> getCheckboxList(String additionalId, String sellerId) async{
    List<Map<String, dynamic>> checkboxArray = [];
    QuerySnapshot checkboxList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("checkbox")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    for (DocumentSnapshot checkboxDoc in checkboxList.docs) {
      // print('checkboxDoc: ${checkboxDoc.data()}');

      try {
        checkboxArray[checkboxDoc['index']] = {
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
        };
        // print('success');
        
      } catch (e) {
        // print('failed');
        // print(e);
        checkboxArray.add({
          "index": checkboxDoc['index'],
          "label": checkboxDoc['label'],
          "value": checkboxDoc['value'],
          "id": checkboxDoc.id,
        });
      }
    }
    return checkboxArray;
  }

  @action
  Future<List<Map<String, dynamic>>> getDropdownList(String additionalId, String sellerId) async{    
    List<Map<String, dynamic>> dropdownArray = [];
    QuerySnapshot dropdownList = await FirebaseFirestore.instance.collection('sellers').doc(sellerId)
      .collection('additional')
      .doc(additionalId)
      .collection("dropdown")
      .where("status", isEqualTo: "ACTIVE")
      .orderBy("index")
      .get();

    for (DocumentSnapshot dropdownDoc in dropdownList.docs) {
      // print('checkboxDoc: ${dropdownDoc.data()}');

      try {
        dropdownArray[dropdownDoc['index']] = {
          "index": dropdownDoc['index'],
          "label": dropdownDoc['label'],
          "value": dropdownDoc['value'],
        };
        // print('success');
        
      } catch (e) {
        // print('failed');
        // print(e);
        dropdownArray.add({
          "index": dropdownDoc['index'],
          "label": dropdownDoc['label'],
          "value": dropdownDoc['value'],
        });
      }
    }
    return dropdownArray;
  }
}

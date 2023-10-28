import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/cart_model.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../core/models/address_model.dart';
import '../../shared/widgets/redirect_popup.dart';
// import '../../core/models/email.dart';
part 'cart_store.g.dart';

class CartStore = _CartStoreBase with _$CartStore;

abstract class _CartStoreBase with Store {
  final MainStore mainStore = Modular.get();
  // @observable
  // double freight = 54.0;
  @observable
  int seconstToFinalize = 0;
  @observable
  String? addressId;
  @observable
  bool canBack = true;
  @observable
  ObservableList cartList = [].asObservable();
  @observable
  OverlayEntry? loadOverlay;
  // @observable
  // String deliveryType = 'express';
  @observable
  int val = 1;
  @observable
  num totalPrice = 0;
  @observable
  num deliveryPrice = 0;
  @observable
  String promotionalCode = '';
  @observable
  num totalPriceWithDiscount = 0;
  @observable
  TextEditingController textEditingController = TextEditingController();
  @observable
  OverlayEntry? redirectOverlay;
  @observable
  num change = 0;
  @observable
  String paymentMethod = 'Saldo em conta';
  @observable
  MapZoomPanBehavior zoomPanBehavior = MapZoomPanBehavior(
    zoomLevel: 5,
    enableDoubleTapZooming: true,
    focalLatLng: MapLatLng(-15.787763, -48.008072),
  );
  @observable
  MapTileLayerController mapTileLayerController = MapTileLayerController();
  @observable
  Address? address;
  @observable
  ObservableList<MapMarker> marker = <MapMarker>[].asObservable();
  // @observable
  // int cardIndex = 0;
  // @observable
  // String cardId = '';
  // @observable
  // String finalNumberCard = '';
  // @observable
  // String flagCard = '';
  // @observable
  // Marker? marker;

  // @observable
  // int installmentCount = 1;
  // @observable
  // List<dynamic> availablePlansList = ["Nenhum"];

  @action
  Future<List<Map<String, dynamic>>> getAdditionalInformations(
      String adsId, String sellerId) async {
    List<Map<String, dynamic>> additionalList = [];
    QuerySnapshot additionalQuery = await FirebaseFirestore.instance
        .collection("ads")
        .doc(adsId)
        .collection('additional')
        .get();
    CartModel cartModel = mainStore.cart[adsId]!;
    Map additionalMap = cartModel.additionalMap;
    print('additionalMap: $additionalMap');

    for (var additionalRef in additionalQuery.docs) {
      Map response = {};
      DocumentSnapshot additionalDoc = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(sellerId)
          .collection('additional')
          .doc(additionalRef.id)
          .get();

      if (additionalDoc['customer_config'] == "edition") {
        print('additionalDoc[type]: ${additionalDoc['type']}');
        switch (additionalDoc['type']) {
          case "check-box":
            Map checkedMap = additionalMap[additionalDoc.id]['checked_map'];
            Map map = {};

            checkedMap.forEach((key, value) {
              map.putIfAbsent(key, () => value['response']);
            });

            response = map;
            break;

          case "radio-button":
            response = {
              "label": additionalMap[additionalDoc.id]['response_label']
            };
            break;

          case "combo-box":
            response = {
              "label": additionalMap[additionalDoc.id]['response_label']
            };
            break;

          case "text-field":
            response = {
              "text": additionalMap[additionalDoc.id]['response_text']
            };
            break;

          case "text-area":
            response = {
              "text": additionalMap[additionalDoc.id]['response_text']
            };
            break;

          case "increment":
            // print('additionalMap[additionalDoc.id]: ${additionalMap[additionalDoc.id]}');
            response = {
              "count": additionalMap[additionalDoc.id]['response_count'],
              "value": additionalMap[additionalDoc.id]['response_value'],
            };
            break;

          default:
            break;
        }
        additionalList.add({
          "doc": additionalDoc,
          "response": response,
        });
      }
    }

    print('additionalList: ${additionalList.length}');

    return additionalList;
  }

  @action
  String foreCast() {
    // if (deliveryType == 'express') {
    DateTime dateTimeNow = DateTime.now().toUtc();

    int hourInt = dateTimeNow.hour;
    int twoHoursLater = hourInt + 2;

    if (hourInt == 22) {
      twoHoursLater = 0;
    }

    if (hourInt == 23) {
      twoHoursLater = 1;
    }

    if (hourInt == 24) {
      twoHoursLater = 2;
    }

    String hour = hourInt.toString().padLeft(2, '0');
    String minute = dateTimeNow.minute.toString().padLeft(2, '0');
    String twoHoursLaterString = twoHoursLater.toString().padLeft(2, '0');
    return hour + ':' + minute + ' - ' + twoHoursLaterString + ':' + minute;
    // } else {
    //   return 'Em até 8 dias úteis';
    // }
  }

  @action
  assembleList() {
    mainStore.cart.forEach((key, value) {
      // print('assembleList: ${value.toJson()}');
      cartList.add(key);
    });
  }

  @action
  void cleanItems() {
    mainStore.cartSellerId = '';
    mainStore.cart.clear();
    // mainStore.cartObj.clear();
    // mainStore.cartObjId.clear();
    cartList.clear();
    totalPrice = 0;
    totalPriceWithDiscount = 0;
    deliveryPrice = 0;
    change = 0;
    // cardId = '';
    // finalNumberCard = '';
    // flagCard = '';
  }

  @action
  void cleanItem(String id) {
    mainStore.cart.remove(id);
    cartList.remove(id);
    if (cartList.length == 0) {
      mainStore.cartSellerId = '';
    }
  }

  @action
  void addItem(String id) {
    CartModel cartModel = mainStore.cart[id]!;
    cartModel.amount++;
    cartModel.totalPrice = cartModel.unitPrice * cartModel.amount;
    mainStore.cart.update(id, (value) => cartModel);
  }

  @action
  void removeItem(String id) {
    CartModel cartModel = mainStore.cart[id]!;
    cartModel.amount--;
    cartModel.totalPrice = cartModel.unitPrice * cartModel.amount;
    mainStore.cart.update(id, (value) => cartModel);
  }

  @action
  Future<List<num>> getSubTotal() async {
    final User? _user = FirebaseAuth.instance.currentUser;
    num subTotal = 0;
    // num priceShipping = deliveryType == 'express' ? 54 : 48;
    num priceShipping = 0;
    num priceTotal = 0;
    num newPriceTotal = 0;
    num discount = 0;

    mainStore.cart.forEach((key, value) {
      CartModel cartModel = value;
      subTotal += cartModel.unitPrice * cartModel.amount;
    });

    // for (CartModel cartModel in mainStore.cartObj) {
    //   subTotal += cartModel.value * cartModel.amount;
    // }

    priceTotal = subTotal + priceShipping;

    QuerySnapshot activedCoupons = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('active_coupons')
        .where('actived', isEqualTo: true)
        .where('used', isEqualTo: false)
        .where('status', isEqualTo: "VALID")
        .orderBy('created_at', descending: true)
        .get();

    if (activedCoupons.docs.isNotEmpty) {
      DocumentSnapshot couponDoc = activedCoupons.docs.first;
      bool hasValueMinimum =
          couponDoc['value_minimum'] != null && couponDoc['value_minimum'] != 0;
      // print("hasValueMinimum: $hasValueMinimum");
      // print(
      //     "couponDoc['value_minimum']: ${couponDoc['value_minimum']} - priceTotal: $priceTotal");

      if (!hasValueMinimum ||
          (hasValueMinimum && couponDoc['value_minimum'] < priceTotal)) {
        if (couponDoc['percent_off'] != null) {
          num percentOff = couponDoc['percent_off'];
          discount = priceTotal * percentOff;
          newPriceTotal = priceTotal - discount;
          newPriceTotal = num.parse(newPriceTotal.toStringAsFixed(2));
          print('percentOff: $percentOff');
          print('subTotal: $subTotal');
          print('priceTotal: $priceTotal');
          print('discount: ${priceTotal * percentOff}');
          print('newPriceTotal: $newPriceTotal');
        } else {
          discount = couponDoc['discount'];
          newPriceTotal = priceTotal - couponDoc['discount'];
          if (newPriceTotal < 0) {
            newPriceTotal = 0;
          }
          print('priceTotal: $priceTotal');
          print('discount and newPriceTotal: $discount - $newPriceTotal');
        }
      }
    } else {
      newPriceTotal = priceTotal;
    }

    totalPrice = priceTotal;
    deliveryPrice = priceShipping;
    totalPriceWithDiscount = newPriceTotal;

    return [subTotal, priceShipping, priceTotal, discount, newPriceTotal];
  }

  @action
  Future<void> validations(BuildContext context) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    canBack = false;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);

    // final sellerId = mainStore.cartObj.first.sellerId;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(currentUser!.uid)
        .get();

    print('validations function2');
    try {
      QuerySnapshot notPaidTransactions = await userDoc.reference
          .collection('transactions')
          .where("status", isNotEqualTo: "PAID")
          .get();
      print('notPaidTransactions: ${notPaidTransactions.docs.length}');

      for (var i = 0; i < notPaidTransactions.docs.length; i++) {
        DocumentSnapshot transactionDoc = notPaidTransactions.docs[i];
        DocumentSnapshot? orderDoc;
        try {
          print("try: ${transactionDoc.id}");
          orderDoc = await FirebaseFirestore.instance
              .collection("orders")
              .doc(transactionDoc.get("order_id"))
              .get();
        } catch (e) {
          print(e);
        }
        if (orderDoc != null) {
          try {
            print("orderDoc.id: ${orderDoc.id}");
            print("orderDoc.get(status): ${orderDoc.get("status")}");
            if (orderDoc.get("status") != "CANCELED" &&
                orderDoc.get("status") != "REFUSED") {
              Modular.to.pushNamed("/cart/order-not-paid", arguments: orderDoc);
              showToast("Você ainda tem um pedido não pago");
              loadOverlay!.remove();
              canBack = true;
              return;
            }
          } catch (e) {
            print(e);
          }
        }
      }
    } catch (e) {
      print(e);
    }
    print('validations function3');

    if (!(await FirebaseFirestore.instance
            .collection("sellers")
            .doc(mainStore.cartSellerId)
            .get())
        .get("online")) {
      showToast("Este vendedor não está online");
      loadOverlay!.remove();
      canBack = true;
      return;
    }

    if (userDoc.get("main_address") == null) {
      showToast("Você precisa de um endereço para continuar");
      loadOverlay!.remove();
      canBack = true;
      return;
    }

    print('paymentMethod: $paymentMethod');
    if (paymentMethod == 'Saldo em conta') {
      List<num> listPrice = await getSubTotal();
      num price = listPrice.last;
      if (price > userDoc['account_balance']) {
        showToast("Saldo em conta insuficiente");
        loadOverlay!.remove();
        canBack = true;
        return;
      }
    }

    for (var i = 0; i < cartList.length; i++) {
      String adsId = cartList[i];
      CartModel cartModel = mainStore.cart[adsId]!;
      DocumentSnapshot itemDoc =
          await FirebaseFirestore.instance.collection('ads').doc(adsId).get();
      if (cartModel.amount > itemDoc['amount']) {
        showToast(
            "O item ${itemDoc['title']} só possui ${itemDoc['amount']} quantidades");
        loadOverlay!.remove();
        loadOverlay = null;

        canBack = true;
        return;
      }
    }

    if (paymentMethod == 'Cartão - pelo APP') {
      QuerySnapshot cards = await userDoc.reference
          .collection('cards')
          .where('status', isEqualTo: 'ACTIVE')
          .get();

      if(cards.docs.length == 0){
        loadOverlay!.remove();
        loadOverlay = null;
        redirectOverlay = OverlayEntry(
          builder: (context) => RedirectPopup(
            height: wXD(140, context),
            text: 'Você ainda não tem cartão, deseja adicionar um?',
            onConfirm: () async {
              redirectOverlay!.remove();

              Modular.to.pushNamed("/add-card");
            },
            onCancel: () {
              redirectOverlay!.remove();
            },
          ),
        );

        Overlay.of(context)?.insert(redirectOverlay!);
        return;
      }
    }
    loadOverlay!.remove();
    loadOverlay = null;
    await Modular.to
      .pushNamed('/cart/finalizing', arguments: paymentMethod == "Pix");
    canBack = true;
  }

  @action
  Future finalizeOrder(context) async {
    canBack = false;
    final User? _user = FirebaseAuth.instance.currentUser;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay!);

    List newList = [];
    int totalAmount = 0;

    mainStore.cart.forEach((key, value) {
      newList.add(value.toJson());
      totalAmount += value.amount;
    });

    var response = await cloudFunction(
      function: "finalizeOrder",
      object: {
        "userId": _user!.uid,
        "sellerId": mainStore.cartSellerId,
        "paymentMethod": getPaymentMethod(),
        "items": newList,
        "price": {
          "deliveryPrice": deliveryPrice,
          "totalPrice": totalPrice,
          "totalPriceWithDiscount": totalPriceWithDiscount,
        },
        "order": {
          "customer_address_id": addressId,
          "customer_id": _user.uid,
          "discontinued_by": null,
          "discontinued_reason": null,
          "end_date": null,
          "start_date": null,
          "customer_token": getRandomString(6),
          "agent_token": getRandomString(6),
          "change": change,
          "total_amount": totalAmount,
          "seller_id": mainStore.cartSellerId,
          "price_total": totalPrice,
          "price_rate_delivery": deliveryPrice,
          "price_total_with_discount": totalPriceWithDiscount,
          "payment_method": getPaymentMethod(),
          "store_name": null,
          'formated_address': null,
          "seller_address": null,
          "customer_formated_address": null,
          "agent_id": null,
          "created_at": null,
          "id": null,
          "code": null,
          "coupon_id": null,
          "status": "INACTIVE",
          "seller_address_id": null,
          "rated": false,
          "user_id_discontinued": null,
          "send_date": null,
          "agent_status": null,
        }
      },
    );

    print('xxxxxxxxxxxxx response $response');

    // if (response['code'] != 'success') {
    //   // if (response['code'] == 'account-balance-insuficient') {
    //   //   showToast('Saldo em conta insuficiente', Colors.red);
    //   // } else {
    //   showToast('Falha ao tentar realizar o pagamento', Colors.red);
    //   // }
    //   loadOverlay!.remove();
    //   loadOverlay = null;
    //   Modular.to.pop();
    // } else {
    //   print('paymentMethod: $paymentMethod');
    //   if (paymentMethod == 'Pix') {
    //     // await sendEmail(response['orderId']);
    //   }
    //   await setUseCoupon();
    //   // await Future.delayed(Duration(milliseconds: 1000));
    //   cleanItems();
    //   if (loadOverlay != null && loadOverlay!.mounted) {
    switch (response['code']) {
      case "succeeded":
        print('paymentMethod: $paymentMethod');
        if (paymentMethod == 'Pix') {
          // await sendEmail(response['orderId']);
        }
        // await setUseCoupon();
        // await Future.delayed(Duration(milliseconds: 1000));
        cleanItems();
        if (loadOverlay != null && loadOverlay!.mounted) {
          loadOverlay!.remove();
          loadOverlay = null;
        }
        Modular.to.pop();
        await mainStore.setPage(3);
        break;

      case "dont-was-selected-payment-method":
        showToast('Forma de pagamento não encontrada', Colors.red);
        loadOverlay!.remove();
        loadOverlay = null;
        Modular.to.pop();
        break;

      // case "after-payment":
      //   if (paymentMethod == 'Pix') {
      //     // await sendEmail(response['orderId']);
      //   }
      //   // await setUseCoupon();
      //   // showToast('', Colors.red);
      //   loadOverlay!.remove();
      //   loadOverlay = null;
      //   Modular.to.pop();
      //   await mainStore.setPage(3);
      //   break;

      default:
        showToast('Falha ao tentar realizar o pagamento', Colors.red);
        loadOverlay!.remove();
        loadOverlay = null;
        Modular.to.pop();
        break;
    }

    // if (response['code'] != 'success') {
    //   // if (response['code'] == 'account-balance-insuficient') {
    //   //   showToast('Saldo em conta insuficiente', Colors.red);
    //   // } else {
    //     showToast('Falha ao tentar realizar o pagamento', Colors.red);
    //   // }
    //   loadOverlay!.remove();
    //   loadOverlay = null;
    //   Modular.to.pop();
    // } else {
    //   print('paymentMethod: $paymentMethod');
    //   if (paymentMethod == 'Pix') {
    //     // await sendEmail(response['orderId']);
    //   }
    //   await setUseCoupon();
    //   // await Future.delayed(Duration(milliseconds: 1000));
    //   cleanItems();
    //   if (loadOverlay != null && loadOverlay!.mounted) {
    //     loadOverlay!.remove();
    //     loadOverlay = null;
    //   }
    //   Modular.to.pop();
    //   await mainStore.setPage(3);
    // }

    canBack = true;
  }

  // @action
  // Future<void> sendEmail(String orderId) async {
  //   print('sendEmail');
  //   final User? _user = FirebaseAuth.instance.currentUser;
  //   DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(_user!.uid)
  //       .get();
  //   print('userDoc[email]: ${userDoc['email']}');
  //   print('userDoc[phone]: ${userDoc['phone']}');
  //   print('orderID: $orderId');
  //   DocumentSnapshot orderDoc = await FirebaseFirestore.instance
  //       .collection("orders")
  //       .doc(orderId)
  //       .get();
  //   QuerySnapshot adsQuery = await orderDoc.reference.collection('ads').get();
  //   print('adsQuery.docs.length: ${adsQuery.docs.length}');
  //   QuerySnapshot infoQuery =
  //       await FirebaseFirestore.instance.collection("info").get();
  //   DocumentSnapshot infoDoc = infoQuery.docs.first;
  //   Email email = Email('scorefyteste@gmail.com', '1Waxzsq2!');
  //   // Email email = Email('mercadoexpresso@scorefy.com', '1Waxzsq2!#');

  //   String itens = "<h1>Itens do pedido:</h1> <ol>";
  //   for (var i = 0; i < adsQuery.docs.length; i++) {
  //     DocumentSnapshot ads = adsQuery.docs[i];
  //     DocumentSnapshot adsDoc =
  //         await FirebaseFirestore.instance.collection('ads').doc(ads.id).get();
  //     itens += "<li>${adsDoc['title']}</li>";
  //   }
  //   itens += "</ol>";
  //   print('itens: $itens');

  //   if (userDoc['email'] != null) {
  //     bool result = await email.sendMessage(
  //       assunto: 'Pedido pendente',
  //       destinatario: userDoc['email'],
  //       html:
  //           '$itens <br/> <p>${userDoc['username']} você solicitou o pedido(${orderDoc.id}) com a forma de pagamento pix.</p> <br/> <p>Para finalizar o pedido só falta o pix no valor de ${formatedCurrency(totalPriceWithDiscount)} R\$.</p> <br/> <p>Chave pix: cnpj 29.412.420/0001-67</p> <br/> <img src="${infoDoc['qrcode_pix_image']}" alt= "Qr code para o pix"/>',
  //     );

  //     print("email customer ${result ? 'Enviado.' : 'Não enviado.'}");
  //   } else {
  //     try {
  //       // WhatsAppUnilink link = WhatsAppUnilink(
  //       //   phoneNumber: userDoc['phone'],
  //       //   text: "Pedido pendente, efetue o pix de ${formatedCurrency(totalPriceWithDiscount)} R\$ para cnpj 29.412.420/0001-67",
  //       // );
  //       // await launch('$link');
  //       // await launch(infoDoc['qrcode_pix_image']);
  //       Fluttertoast.showToast(
  //         msg:
  //             "Pedido pendente, efetue o pix de ${formatedCurrency(totalPriceWithDiscount)} R\$ para o cnpj 29.412.420/0001-67",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //     } catch (e) {
  //       print('error');
  //       print(e);
  //     }
  //   }

  //   bool result2 = await email.sendMessage(
  //     assunto: 'Novo pedido',
  //     destinatario: "scorefyteste@gmail.com",
  //     html:
  //         '$itens <br/> <p>${userDoc['username']} solicitou o pedido(${orderDoc.id}) com a forma de pagamento pix.</p> <br/> <p>Para finalizar o pedido só falta o pix no valor de ${formatedCurrency(totalPriceWithDiscount)} R\$.</p> <br/> <p>Chave pix: cnpj 29.412.420/0001-67</p>',
  //   );

  //   print("email scorefy${result2 ? 'Enviado.' : 'Não enviado.'}");
  // }

  @action
  String getPaymentMethod() {
    print('getPaymentMethod: $paymentMethod ');
    switch (paymentMethod) {
      case 'Cartão':
        return 'CARD';

      case 'Saldo em conta':
        return 'ACCOUNT-BALANCE';

      case 'Dinheiro':
        return 'MONEY';

      case 'Pix':
        return 'PIX';

      case 'Cartão - pelo APP':
        return 'CARD-BY-APP';

      default:
        return '';
    }
  }

  @action
  findCoupon(BuildContext context) async {
    if (promotionalCode != '') {
      // String? _messageError;
      loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
      Overlay.of(context)!.insert(loadOverlay!);
      canBack = false;
      final User? _user = FirebaseAuth.instance.currentUser;

      QuerySnapshot activedCoupons = await FirebaseFirestore.instance
          .collection('customers')
          .doc(_user!.uid)
          .collection('active_coupons')
          .where('actived', isEqualTo: true)
          .where('used', isEqualTo: false)
          .where('status', isEqualTo: 'VALID')
          .get();

      print('activedCoupons: ${activedCoupons.docs.length}');

      if (activedCoupons.docs.isEmpty) {
        QuerySnapshot findCouponsQuery = await FirebaseFirestore.instance
            .collection('customers')
            .doc(_user.uid)
            .collection('active_coupons')
            .where('code', isEqualTo: promotionalCode)
            .where('used', isEqualTo: false)
            .where('status', isEqualTo: 'VALID')
            .get();

        print('findCouponsQuery: ${findCouponsQuery.docs.length}');

        if (findCouponsQuery.docs.isNotEmpty) {
          DocumentSnapshot findCouponDoc = findCouponsQuery.docs.first;
          await findCouponDoc.reference.update({
            'actived': true,
          });
          promotionalCode = '';
          textEditingController.clear();
        } else {
          Fluttertoast.showToast(
            msg: "Cupom não encontrado",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print('Cupom não encontrado');
          // _messageError = 'Cupom não encontrado';
        }
      } else {
        DocumentSnapshot activeCouponDoc = activedCoupons.docs.first;
        print(
            'activeCouponDoc: ${activeCouponDoc['type']} - ${activeCouponDoc['code']}');

        if (activeCouponDoc['code'] != promotionalCode) {
          if (activeCouponDoc['type'] == "FRIEND_INVITE") {
            Fluttertoast.showToast(
              msg: "Só é possível ter um cupom por pedido",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            print('Só é possível ter um cupom por pedido');
            // _messageError = 'Cupom não encontrado';
          } else {
            QuerySnapshot findCouponsQuery = await FirebaseFirestore.instance
                .collection('customers')
                .doc(_user.uid)
                .collection('active_coupons')
                .where('code', isEqualTo: promotionalCode)
                .where('used', isEqualTo: false)
                .where('status', isEqualTo: 'VALID')
                .get();

            print('findCouponsQuery: ${findCouponsQuery.docs.length}');

            if (findCouponsQuery.docs.isNotEmpty) {
              DocumentSnapshot findCouponDoc = findCouponsQuery.docs.first;

              QuerySnapshot activedCouponQuery = await FirebaseFirestore
                  .instance
                  .collection('customers')
                  .doc(_user.uid)
                  .collection('active_coupons')
                  .where('actived', isEqualTo: true)
                  .where('used', isEqualTo: false)
                  .where('status', isEqualTo: 'VALID')
                  .get();

              print('activedCouponQuery: ${activedCouponQuery.docs.length}');

              if (activedCouponQuery.docs.isNotEmpty) {
                await activedCouponQuery.docs.first.reference.update({
                  'actived': false,
                });
              }
              await findCouponDoc.reference.update({
                'actived': true,
              });
              promotionalCode = '';
              textEditingController.clear();
            } else {
              Fluttertoast.showToast(
                msg: "Cupom não encontrado",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              print('Cupom não encontrado');
              // _messageError = 'Cupom não encontrado';
            }
          }
        } else {
          Fluttertoast.showToast(
            msg: 'Este cupom já está sendo utilizado',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          print('Este cupom já está sendo utilizado');
        }
      }
      canBack = true;
      loadOverlay!.remove();
      loadOverlay = null;
    }
  }

  // setUseCoupon() async {
  //   final User? _user = FirebaseAuth.instance.currentUser;

  //   QuerySnapshot activedCoupons = await FirebaseFirestore.instance
  //       .collection('customers')
  //       .doc(_user!.uid)
  //       .collection('active_coupons')
  //       .where('actived', isEqualTo: true)
  //       .where('used', isEqualTo: false)
  //       .where('status', isEqualTo: 'VALID')
  //       .get();

  //   if (activedCoupons.docs.isNotEmpty) {
  //     await activedCoupons.docs.first.reference
  //         .update({'actived': false, 'used': true});
  //     FirebaseFirestore.instance
  //         .collection('coupons')
  //         .doc(activedCoupons.docs.first.id)
  //         .update({'actived': false, 'used': true});
  //   }
  // }

  @action
  Future<QuerySnapshot> getAvailableCards() async {
    final User? _user = FirebaseAuth.instance.currentUser;
    QuerySnapshot cards = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_user!.uid)
        .collection('cards')
        .orderBy('created_at', descending: true)
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    return cards;
  }

  // @action
  // Future<void> setMarker(Address address, context) async {
  //   marker = Marker(
  //     markerId: MarkerId("main_address"),
  //     position: LatLng(
  //       address.latitude!,
  //       address.longitude!,
  //     ),
  //     icon: await bitmapDescriptorFromSvgAsset(
  //         context, "./assets/svg/location.svg"),
  //   );
  // }
}

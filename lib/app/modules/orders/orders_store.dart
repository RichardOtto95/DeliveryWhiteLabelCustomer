import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/core/models/directions_model.dart';
import 'package:delivery_customer/app/core/models/order_model.dart';
import 'package:delivery_customer/app/core/models/time_model.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../../core/models/agent_model.dart';
import '../../core/services/directions/network_helper.dart';
import 'package:cloud_functions/cloud_functions.dart';

part 'orders_store.g.dart';

class OrdersStore = _OrdersStoreBase with _$OrdersStore;

abstract class _OrdersStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  List<String> viewableOrderStatus = [
    "REQUESTED",
    "PROCESSING",
    "SENDED",
    "DELIVERY_ACCEPTED",
    "DELIVERY_REQUESTED",
    "DELIVERY_REFUSED",
    "TIMEOUT",
  ];
  // @observable
  // bool montingList = false;
  @observable
  bool canBack = true;
  @observable
  String? adsId;
  @observable
  String? deliveryForecast;
  @observable
  String deliveryForecastLabel = "Previsão de entrega";
  @observable
  OverlayEntry? loadOverlayEvaluation;
  // @observable
  // GoogleMapController? googleMapController;
  // @observable
  // Order? order;
  // @observable
  // Seller? seller;
  // @observable
  // Customer? customer;
  // @observable
  // Agent? agent;
  // @observable
  // Marker? origin;
  // @observable
  // Marker? destination;
  // @observable
  // MapMarker? agentMapMarker;
  // @observable
  // MapMarker? destinyMapMarker;
  // @observable
  // MapMarker? sellerMapMarker;
  // @observable
  // MapMarker? customerMapMarker;
  // @observable
  // MapMarker? agentLocation;
  @observable
  List<MapLatLng> polyPoints = [];
  // @observable
  // DirectionsOSMap? destinyRoute;
  @observable
  MapTileLayerController? mapTileLayerController;
  @observable
  MapZoomPanBehavior? zoomPanBehavior;
  @observable
  ObservableList<MapMarker> mapMarkersList = <MapMarker>[].asObservable();
  // @observable
  // Address? storeAddress;
  // @observable
  // Address? customerAddress;
  @observable
  Address? destinationAddress;
  @observable
  Directions? info;
  // @observable
  // ignore: cancel_subscriptions
  // StreamSubscription<DocumentSnapshot>? orderSubs;
  @observable
  // ignore: cancel_subscriptions
  StreamSubscription<DocumentSnapshot>? agentListen;
  @observable
  ObservableList steps = [].asObservable();
  @observable
  OverlayEntry? overlayCancel;

  @action
  void sendMessage(DocumentSnapshot orderDoc) {
    // print("orderdoc: ${orderDoc.data()}");
    if (orderDoc['status'] == "SENDED") {
      Modular.to.pushNamed('/messages/chat', arguments: {
        "receiverId": orderDoc['agent_id'],
        "receiverCollection": "agents",
      });
    } else {
      Modular.to.pushNamed('/messages/chat', arguments: {
        "receiverId": orderDoc['seller_id'],
        "receiverCollection": "sellers",
      });
    }
  }

  // @action
  // Future<void> addOrderListener(orderId, context) async {
  //   Stream<DocumentSnapshot> orderSnap = FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(mainStore.authStore.user!.uid)
  //       .collection("orders")
  //       .doc(orderId)
  //       .snapshots();

  //   orderSubs = orderSnap.listen((_orderDoc) async {
  //     print("_orderDoc: ${_orderDoc.get("status")}");
  //     getShippingDetails(_orderDoc, context);
  //     // deliveryForecast = await getDeliveryForecast(_orderDoc);
  //   });
  // }

  // @action
  // Future getShippingDetails(DocumentSnapshot orderDoc, context) async {
  //   Order _orderModel = Order.fromDoc(orderDoc);

  //   steps = [
  //     {
  //       'title': 'Aguardando confirmação',
  //       'sub_title': 'Aguarde a confirmação da loja',
  //     },
  //     {
  //       'title': 'Em preparação',
  //       'sub_title': 'O vendedor está preparando o seu pacote.',
  //     },
  //     {
  //       'title': 'A caminho',
  //       'sub_title': 'Seu pacote está a caminho',
  //     },
  //     {
  //       'title': 'Entregue',
  //       'sub_title': '',
  //     },
  //   ].asObservable();

  //   if (_orderModel.status == "REQUESTED") {
  //     deliveryForecast = "Nenhuma";
  //   }

  //   if (_orderModel.status == "REFUSED") {
  //     steps[0]["title"] = "Pedido recusado";
  //     steps[0]["sub_title"] = "O vendedor recusou o seu pedido";
  //   }

  //   if (_orderModel.status! == "CANCELED") {
  //     steps[1]["title"] = "Pedido cancelado";
  //     steps[1]["sub_title"] = "O seu pedido foi cancelado";
  //   }

  //   if (_orderModel.status! == "DELIVERY_REFUSED") {
  //     steps[1]["title"] = "Envio recusado";
  //     steps[1]["sub_title"] = "O agente recusou a entrega";
  //   }

  //   if (_orderModel.status! == "DELIVERY_CANCELED") {
  //     steps[2]["title"] = "Envio cancelado";
  //     steps[2]["sub_title"] = "O agente cancelou a entrega";
  //   }

  //   if (_orderModel.status! == "CONCLUDED") {
  //     String _hour = Time(_orderModel.endDate!.toDate()).hour();
  //     String _period = "PM";
  //     if (int.parse(_hour.substring(0, 2)) <= 12) {
  //       _period = "AM";
  //     }
  //     steps[3]["sub_title"] = "Seu pedido foi entregue às $_hour $_period";
  //   }

  //   DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
  //       .collection("sellers")
  //       .doc(_orderModel.sellerId)
  //       .get();

  //   seller = Seller.fromDoc(sellerDoc);

  //   DocumentSnapshot customerDoc = await FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(_orderModel.customerId)
  //       .get();

  //   print("customerDoc ${customerDoc.data()}");

  //   customer = Customer.fromDoc(customerDoc);

  //   Address storeAddress = Address.fromDoc(await FirebaseFirestore.instance
  //       .collection("sellers")
  //       .doc(_orderModel.sellerId)
  //       .collection("addresses")
  //       .doc(_orderModel.sellerAdderessId)
  //       .get());

  //   Address customerAddress = Address.fromDoc(await FirebaseFirestore.instance
  //       .collection("customers")
  //       .doc(_orderModel.customerId)
  //       .collection("addresses")
  //       .doc(_orderModel.customerAdderessId)
  //       .get());

  //   if (_orderModel.status == "DELIVERY_ACCEPTED") {
  //     destinationAddress = storeAddress;
  //   } else {
  //     destinationAddress = customerAddress;
  //   }

  //   LatLng storeLatLng =
  //       LatLng(storeAddress.latitude!, storeAddress.longitude!);

  //   LatLng customerLatLng =
  //       LatLng(customerAddress.latitude!, customerAddress.longitude!);

  //   destination = Marker(
  //     markerId: MarkerId("destination"),
  //     infoWindow: InfoWindow(title: "destination"),
  //     icon: await bitmapDescriptorFromSvgAsset(
  //         context, "./assets/svg/location.svg"),
  //     position:
  //         _orderModel.status == "DELIVERY_ACCEPTED" ? storeLatLng : customerLatLng,
  //   );

  //   if (_orderModel.agentId != null &&
  //       _orderModel.status != "CONCLUDED" &&
  //       _orderModel.status != "CANCELED") {
  //     Stream<DocumentSnapshot> agentStream = FirebaseFirestore.instance
  //         .collection("agents")
  //         .doc(_orderModel.agentId)
  //         .snapshots();

  //     agentStream.listen((_agentDoc) async {
  //       Agent _agent = Agent.fromDoc(_agentDoc);

  //       double _agentLatitude = _agent.position!["latitude"];
  //       double _agentLongitude = _agent.position!["longitude"];

  //       LatLng agentLatLng = LatLng(
  //         _agentLatitude,
  //         _agentLongitude,
  //       );

  //       info = await DirectionRepository().getDirections(
  //         origin: agentLatLng,
  //         destination: destination!.position,
  //       );

  //       origin = Marker(
  //           markerId: MarkerId("origin"),
  //           infoWindow: InfoWindow(title: "origin"),
  //           icon: await bitmapDescriptorFromSvgAsset(
  //               context, "./assets/svg/location.svg"),
  //           position: agentLatLng);

  //       if (googleMapController != null)
  //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //           googleMapController!.animateCamera(
  //               CameraUpdate.newLatLngBounds(info!.bounds, wXD(10, context)));
  //         });

  //       Directions? _storeDirection = await DirectionRepository().getDirections(
  //         origin: agentLatLng,
  //         destination: storeLatLng,
  //       );

  //       Directions? _customerDirection =
  //           await DirectionRepository().getDirections(
  //         origin: _orderModel.agentStatus == "GOING_TO_CUSTOMER"
  //             ? agentLatLng
  //             : storeLatLng,
  //         destination: customerLatLng,
  //       );
  //       if (_orderModel.status == "DELIVERY_ACCEPTED") {
  //         destinationAddress = storeAddress;
  //         if (_storeDirection != null && _customerDirection != null) {
  //           DateTime _deliveryForecast = DateTime.now().add(Duration(
  //               seconds: _storeDirection.durationValue +
  //                   _customerDirection.durationValue +
  //                   600));

  //           String period = " PM";
  //           if (_deliveryForecast.hour < 12) {
  //             period = " AM";
  //           }
  //           deliveryForecast = Time(_deliveryForecast).hour() + period;
  //         } else {
  //           deliveryForecast = "Sem previsão";
  //         }
  //       } else if (_orderModel.status == "SENDED") {
  //         if (_storeDirection != null && _customerDirection != null) {
  //           DateTime _deliveryForecast = DateTime.now()
  //               .add(Duration(seconds: _customerDirection.durationValue + 600));

  //           String period = " PM";
  //           if (_deliveryForecast.hour < 12) {
  //             period = " AM";
  //           }
  //           deliveryForecast = Time(_deliveryForecast).hour() + period;
  //         } else {
  //           deliveryForecast = "Sem previsão";
  //         }
  //       }
  //     });
  //   } else if (_orderModel.status == "CANCELED") {
  //     deliveryForecastLabel = "Pedido cancelado";
  //     deliveryForecast = "Sem previsão de entrega";
  //   } else {
  //     origin = null;
  //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //       if (googleMapController != null)
  //         googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
  //             CameraPosition(target: destination!.position, zoom: 14)));
  //     });
  //   }
  // }

  @action
  void clearShippingDetails() {
    // if (googleMapController != null) googleMapController!.dispose();
    if (agentListen != null) agentListen!.cancel();
    // if (orderSubs != null) orderSubs!.cancel();
    // order = null;
    // seller = null;
    // customer = null;
    // agent = null;
    // origin = null;
    // destination = null;
    destinationAddress = null;
    info = null;
    deliveryForecast = null;
  }

  @action
  Future<Map<String, dynamic>> getRoute(String orderId, context) async {
    DocumentSnapshot orderDoc = await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .get();
    // print('orderDoc: ${orderDoc.data()}');
    Order _order = Order.fromDoc(orderDoc);
    print('_order: ${_order.id}');

    steps = [
      {
        'title': 'Aguardando confirmação',
        'sub_title': 'Aguarde a confirmação da loja',
      },
      {
        'title': 'Em preparação',
        'sub_title': 'O vendedor está preparando o seu pacote.',
      },
      {
        'title': 'A caminho',
        'sub_title': 'Seu pacote está a caminho',
      },
      {
        'title': 'Entregue',
        'sub_title': '',
      },
    ].asObservable();

    if (_order.status == "REQUESTED") {
      deliveryForecast = "Nenhuma";
    }

    if (_order.status == "REFUSED") {
      steps[0]["title"] = "Pedido recusado";
      steps[0]["sub_title"] = "O vendedor recusou o seu pedido";
    }

    if (_order.status! == "CANCELED") {
      steps[1]["title"] = "Pedido cancelado";
      steps[1]["sub_title"] = "O seu pedido foi cancelado";
    }

    if (_order.status! == "DELIVERY_REFUSED") {
      steps[1]["title"] = "Envio recusado";
      steps[1]["sub_title"] = "O agente recusou a entrega";
    }

    if (_order.status! == "DELIVERY_CANCELED") {
      steps[2]["title"] = "Envio cancelado";
      steps[2]["sub_title"] = "O agente cancelou a entrega";
    }

    if (_order.status! == "CONCLUDED") {
      String _hour = Time(_order.endDate!.toDate()).hour();
      String _period = "PM";
      if (int.parse(_hour.substring(0, 2)) <= 12) {
        _period = "AM";
      }
      steps[3]["sub_title"] = "Seu pedido foi entregue às $_hour $_period";
    }

    print('_order.status ${_order.status}');
    print('_order.agentId ${_order.agentId}');

    if (_order.status == "CANCELED") {
      deliveryForecastLabel = "Pedido cancelado";
      deliveryForecast = "Sem previsão de entrega";
    } else if (_order.status == "CONCLUDED") {
      deliveryForecastLabel = "Pedido concluído";
      deliveryForecast = "Entregue";
    }

    if (_order.agentId != null &&
        _order.status != "CONCLUDED" &&
        _order.status != "CANCELED") {
      Address _destinyAddress;

      if (_order.status == "DELIVERY_ACCEPTED") {
        Address _sellerAddress = Address.fromDoc(await FirebaseFirestore
            .instance
            .collection("sellers")
            .doc(_order.sellerId)
            .collection("addresses")
            .doc(_order.sellerAddressId)
            .get());

        _destinyAddress = _sellerAddress;
      } else {
        Address _customerAddress = Address.fromDoc(await FirebaseFirestore
            .instance
            .collection("customers")
            .doc(_order.customerId)
            .collection("addresses")
            .doc(_order.customerAddressId)
            .get());

        _destinyAddress = _customerAddress;
      }

      destinationAddress = _destinyAddress;

      double? _latitude = _destinyAddress.latitude!;
      double? _longitude = _destinyAddress.longitude!;

      MapMarker _destinyMapMarker = MapMarker(
        latitude: _latitude,
        longitude: _longitude,
        child: Icon(
          _order.status == "DELIVERY_ACCEPTED"
              ? Icons.store
              : Icons.location_on,
          color: getColors(context).primary,
        ),
      );
      print("step 111111111111111111111");

      mapMarkersList.add(_destinyMapMarker);
      mapTileLayerController!.insertMarker(0);

      DocumentSnapshot agentDoc = await FirebaseFirestore.instance
          .collection("agents")
          .doc(_order.agentId)
          .get();

      MapMarker _agentMapMarker = MapMarker(
        latitude: agentDoc['position']['latitude'],
        longitude: agentDoc['position']['longitude'],
        child: Icon(
          Icons.motorcycle,
          color: getColors(context).primary,
        ),
      );
      print("step 2222222222222222222222222 : $mapTileLayerController");

      if (mapTileLayerController != null) {
        print(
            "step 2222222222222222222222222 : ${mapTileLayerController!.markersCount}");
        if (mapTileLayerController!.markersCount == 0) {
          mapMarkersList.add(_agentMapMarker);
          mapTileLayerController!.insertMarker(1);
        } else {
          mapMarkersList[1] = _agentMapMarker;
          mapTileLayerController!.updateMarkers([1]);
        }
      }
      print("step 333333333333333333333333333");

      NetworkHelper network = NetworkHelper(
        startLat: agentDoc['position']['latitude'],
        startLng: agentDoc['position']['longitude'],
        endLat: _destinyMapMarker.latitude,
        endLng: _destinyMapMarker.longitude,
      );

      try {
        Map response = await network.getData();

        print("step 44444444444444444444444444444");

        DirectionsOSMap _destinyDirection = response['direction'];

        polyPoints = _destinyDirection.polyPoints;
        zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

        DateTime _deliveryForecast = DateTime.now().add(
          Duration(
            seconds: _destinyDirection.durationValue.toInt() +
                _destinyDirection.durationValue.toInt() +
                600,
          ),
        );
        print("step 55555555555555555555555555555");

        String period = " PM";
        if (_deliveryForecast.hour < 12) {
          period = " AM";
        }

        deliveryForecast = Time(_deliveryForecast).hour() + period;
      } catch (e) {
        print("error on try");
        print(e);
      }

      print("step 6666666666666");

      Stream<DocumentSnapshot> agentStream = FirebaseFirestore.instance
          .collection("agents")
          .doc(_order.agentId)
          .snapshots();

      agentListen = agentStream.listen((_agentDoc) async {
        Agent _agent = Agent.fromDoc(_agentDoc);

        double _agentLatitude = _agent.position!["latitude"];
        double _agentLongitude = _agent.position!["longitude"];

        MapMarker _agentMapMarker = MapMarker(
          latitude: _agentLatitude,
          longitude: _agentLongitude,
          child: Icon(
            Icons.motorcycle,
            color: getColors(context).primary,
          ),
        );

        if (mapTileLayerController != null) {
          if (mapTileLayerController!.markersCount == 1) {
            mapMarkersList.add(_agentMapMarker);
            mapTileLayerController!.insertMarker(1);
          } else {
            mapMarkersList[1] = _agentMapMarker;
            mapTileLayerController!.updateMarkers([1]);
          }
        }

        NetworkHelper network = NetworkHelper(
          startLat: _agentLatitude,
          startLng: _agentLongitude,
          endLat: _destinyMapMarker.latitude,
          endLng: _destinyMapMarker.longitude,
        );

        try {
          Map response = await network.getData();

          DirectionsOSMap _destinyDirection = response['direction'];

          polyPoints = _destinyDirection.polyPoints;
          zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

          DateTime _deliveryForecast = DateTime.now().add(
            Duration(
              seconds: _destinyDirection.durationValue.toInt() +
                  _destinyDirection.durationValue.toInt() +
                  600,
            ),
          );

          String period = " PM";
          if (_deliveryForecast.hour < 12) {
            period = " AM";
          }

          deliveryForecast = Time(_deliveryForecast).hour() + period;
        } catch (e) {
          print("error on try");
          print(e);
        }
      });

      // Position _position = await Geolocator.getCurrentPosition();

      return {
        // "user-current-position": _position,
        "status": "SUCCESS",
        "error-code": null,
      };
    } else {
      Address _customerAddress = Address.fromDoc(await FirebaseFirestore
          .instance
          .collection("customers")
          .doc(_order.customerId)
          .collection("addresses")
          .doc(_order.customerAddressId)
          .get());

      destinationAddress = _customerAddress;

      MapLatLng _customerLatLng =
          MapLatLng(_customerAddress.latitude!, _customerAddress.longitude!);

      MapMarker _customerMapMarker = MapMarker(
        latitude: _customerLatLng.latitude,
        longitude: _customerLatLng.longitude,
        child: Icon(
          Icons.location_on,
          color: getColors(context).primary,
        ),
      );

      Address _sellerAddress = Address.fromDoc(await FirebaseFirestore.instance
          .collection("sellers")
          .doc(_order.sellerId)
          .collection("addresses")
          .doc(_order.sellerAddressId)
          .get());

      MapLatLng _sellerLatLng =
          MapLatLng(_sellerAddress.latitude!, _sellerAddress.longitude!);

      MapMarker _sellerMapMarker = MapMarker(
        latitude: _sellerLatLng.latitude,
        longitude: _sellerLatLng.longitude,
        child: Icon(
          Icons.store,
          color: getColors(context).primary,
        ),
      );

      mapMarkersList.addAll([
        _customerMapMarker,
        _sellerMapMarker,
      ]);

      NetworkHelper network = NetworkHelper(
        startLat: _sellerLatLng.latitude,
        startLng: _sellerLatLng.longitude,
        endLat: _customerLatLng.latitude,
        endLng: _customerLatLng.longitude,
      );

      try {
        Map response = await network.getData();

        DirectionsOSMap _destinyDirection = response['direction'];

        polyPoints = _destinyDirection.polyPoints;
        zoomPanBehavior!.latLngBounds = _destinyDirection.bounds;

        DateTime _deliveryForecast = DateTime.now().add(
          Duration(
            seconds: _destinyDirection.durationValue.toInt() +
                _destinyDirection.durationValue.toInt() +
                600,
          ),
        );

        String period = " PM";
        if (_deliveryForecast.hour < 12) {
          period = " AM";
        }

        deliveryForecast = Time(_deliveryForecast).hour() + period;
      } catch (e) {
        print("error network getData");

        print(e);
      }

      // Position _position = await Geolocator.getCurrentPosition();
      return {
        // "user-current-position": _position,
        "status": "SUCCESS",
        "error-code": null,
      };
    }
  }

  @action
  Future evaluate(Map<String, dynamic> ratings, BuildContext context) async {
    // ratings = {"sellers": Rating, "agents": Rating, "ads": [Rating]}

    loadOverlayEvaluation =
        OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlayEvaluation!);
    canBack = false;

    List<Map<String, dynamic>> evaluateData = [
      ratings["sellers"].toJson(),
      ratings["agents"].toJson(),
    ];

    if (ratings["scorefy"] != null)
      evaluateData.add(ratings["scorefy"].toJson());

    ratings["ads"].forEach((ads) => evaluateData.add(ads.toJson()));

    print("evaluateData: $evaluateData");

    await cloudFunction(
        function: "evaluate", object: {"ratings": evaluateData});

    canBack = true;
    loadOverlayEvaluation!.remove();
    Modular.to.pop();
    showToast("Avaliação realizada com sucesso");
  }

  @action
  Future<void> cancelOrder(context, DocumentSnapshot orderDoc) async {
    late OverlayEntry loadOverlay;
    canBack = false;
    loadOverlay = OverlayEntry(builder: (_) => LoadCircularOverlay());
    Overlay.of(context)!.insert(loadOverlay);

    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable("cancelOrder");
    try {
      print('tryyyyyyy');
      HttpsCallableResult<Map> response = await callable.call({
        "orderId": orderDoc['id'],
        "id": orderDoc['id'],
        "sellerId": orderDoc['seller_id'],
        "customerId": orderDoc['customer_id'],
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "userCollection": "customers",
        "agentId": null,
      });
      print('response: ${response.data}');
      Map responseMap = response.data;
      showToast(responseMap['message']);
    } catch (e) {
      print(e);
    }

    canBack = true;
    loadOverlay.remove();
  }
}

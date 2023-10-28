import 'package:delivery_customer/app/constants/.env.dart';
import 'package:delivery_customer/app/modules/address/widgets/custom_place_picker.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart';
import 'dart:convert';

part 'address_store.g.dart';

class AddressStore = _AddressStoreBase with _$AddressStore;

abstract class _AddressStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  OverlayEntry? editAddressOverlay;
  @observable
  OverlayEntry? addresEditionOverlay;
  @observable
  bool hasAddress = false;
  // @observable
  // bool addressOverlay = false;
  @observable
  bool canBack = false;
  @observable
  GoogleMapController? mapController;
  @observable
  LatLng latLng = LatLng(-15.787747, -48.008066);
  @observable
  CameraPosition cameraPosition = CameraPosition(
    zoom: 14,
    target: LatLng(-15.787747, -48.008066),
  );
  @observable
  Circle? circle;

  @action
  getCanBack() => canBack;

  @action
  Future<Address?> getLocation(context, Address address) async {
    loc.Location location = loc.Location();
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    loc.PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    loc.LocationData _locationData = await location.getLocation();

    if (_locationData.latitude != null && _locationData.longitude != null) {
      latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

      circle = Circle(
        circleId: const CircleId("car"),
        radius: _locationData.accuracy ?? 0,
        zIndex: 1,
        strokeColor: getColors(context).primary,
        center: latLng,
        fillColor: getColors(context).primary.withAlpha(70),
        strokeWidth: 12,
      );

      address = await setAddressByLatLng(context, latLng, address);

      setLatLng(latLng);
    }
    return address;
  }

  @action
  Future<Map<String, dynamic>> searchPlaces(context, String query) async {
    var _sessionToken = Uuid().generateV4();

    String _host =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/textsearch/json';

    final url = '$_host?query=$query&region=br&limit=8&key=$googleAPIKey';

    final Response response = await get(Uri.parse(url), headers: {
      "Access-Control-Allow-Origin": "*",
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer " + _sessionToken,
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    });

    Map<String, dynamic> values = {};

    values = json.decode(response.body);

    return values;
  }

  @action
  Future<Address> getAddressByLocation(context, Address address) async {
    latLng = await mapController!.getLatLng(ScreenCoordinate(
      x: (maxWidth(context) / 2).truncate(),
      y: (maxHeight(context) / 2).truncate(),
    ));

    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleAPIKey);

    LatLon latLon = LatLon(latLng.latitude, latLng.longitude);

    GeocodingResponse? geoResponse =
        await googleGeocoding.geocoding.getReverse(latLon);

    if (geoResponse != null && geoResponse.results != null) {
      address = Address.fromGeoResult(geoResponse.results!.first, address);
      address.latitude = latLng.latitude;
      address.longitude = latLng.longitude;
    }

    return address;
  }

  @action
  Future<Address> setAddressByLatLng(context, LatLng _latLng, Address address) async {
    OverlayEntry loadOverlay =
        OverlayEntry(builder: (context) => LoadCircularOverlay());

    Overlay.of(context)!.insert(loadOverlay);

    GoogleGeocoding googleGeocoding = GoogleGeocoding(googleAPIKey);

    LatLon latLon = LatLon(latLng.latitude, latLng.longitude);

    GeocodingResponse? geoResponse =
        await googleGeocoding.geocoding.getReverse(latLon);

    if (geoResponse != null && geoResponse.results != null) {
      address = Address.fromGeoResult(geoResponse.results!.first, address);
    }

    loadOverlay.remove();
    setLatLng(_latLng);
    return address;
  }

  @action
  Future<void> setLatLng(LatLng _latLng) async {
    latLng = _latLng;

    cameraPosition = CameraPosition(
      zoom: 20,
      target: latLng,
    );

    if (mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }
  }

  @action
  newAddress(Address address, context, bool editing) async {
    canBack = false;

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);
    String functionName = "newAddress";

    if (editing) {
      functionName = "editAddress";
    }

    Map<String, dynamic> addressMap = address.toJson();

    if (addressMap.containsKey("created_at")) {
      addressMap.remove("created_at");
    }

    final user = FirebaseAuth.instance.currentUser!;

    await cloudFunction(function: functionName, object: {
      "address": addressMap,
      "collection": "customers",
      "userId": user.uid,
    });

    overlayEntry.remove();
    canBack = true;
  }

  @action
  setMainAddress(String addressId) async {
    final User _user = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection("customers")
      .doc(_user.uid)
      .get();

    if(userDoc.get("main_address") != null){
      await userDoc.reference
        .collection("addresses")
        .doc(userDoc.get("main_address"))
        .update({
          "main": false,
        });
    }


    await userDoc.reference
      .collection("addresses")
      .doc(addressId)
      .update({
        "main": true,
      });

    await userDoc.reference
      .update({
        "main_address": addressId,
      });
  }

  @action
  Future<void> deleteAddress(context, Address address) async {
    canBack = false;
    final User user = FirebaseAuth.instance.currentUser!;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context)!.insert(overlayEntry);

    DocumentSnapshot _userDoc = await FirebaseFirestore.instance
        .collection("customers")
        .doc(user.uid)
        .get();

    await _userDoc.reference
      .collection("addresses")
      .doc(address.id)
      .update({
        "status": "DELETED", 
        "main": false,
      });

    if (_userDoc.get("main_address") == address.id) {
      String? mainAddress = null;

      QuerySnapshot activeAddresses = await _userDoc.reference
        .collection("addresses")
        .where("status", isEqualTo: "ACTIVE")
        .orderBy("created_at", descending: true)
        .get();

      if (activeAddresses.docs.isNotEmpty) {
        await activeAddresses.docs.first.reference.update({"main": true});
        mainAddress = activeAddresses.docs.first.id;
      }

      await _userDoc.reference.update({"main_address": mainAddress});
    }

    overlayEntry.remove();
    canBack = true;
  }
}

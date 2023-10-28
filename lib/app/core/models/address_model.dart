import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_geocoding/google_geocoding.dart';

class Address {
  String? addressComplement;
  String? addressName;
  String? addressNumber;
  String? cep;
  String? city;
  Timestamp? createdAt;
  String? formatedAddress;
  String? id;
  double? latitude;
  double? longitude;
  bool? main;
  String? neighborhood;
  String? state;
  String? status;
  bool? withoutComplement;
  // String? placeId;

  Address({
    this.addressComplement,
    this.addressName,
    this.addressNumber,
    this.cep,
    this.city,
    this.createdAt,
    this.formatedAddress,
    this.id,
    this.latitude,
    this.longitude,
    this.main,
    this.neighborhood,
    this.state,
    this.status,
    this.withoutComplement,
    // this.placeId,
  });

  factory Address.fromDoc(DocumentSnapshot doc) => Address(
        addressComplement: doc["address_complement"],
        addressName: doc["address_name"],
        addressNumber: doc["address_number"],
        cep: doc["cep"],
        city: doc["city"],
        createdAt: doc["created_at"],
        formatedAddress: doc["formated_address"],
        id: doc["id"],
        latitude: doc["latitude"],
        longitude: doc["longitude"],
        main: doc["main"],
        neighborhood: doc["neighborhood"],
        state: doc["state"],
        status: doc["status"],
        withoutComplement: doc["without_complement"],
        // placeId: doc["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "address_complement": addressComplement,
        "address_name": addressName,
        "address_number": addressNumber,
        "cep": cep,
        "city": city,
        "created_at": createdAt,
        "formated_address": formatedAddress,
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "main": main,
        "neighborhood": neighborhood,
        "state": state,
        "status": status,
        "without_complement": withoutComplement,
        // "place_id": placeId,
      };

  factory Address.fromJson(Map<String, dynamic> map) => Address(
        addressComplement: map["address_complement"],
        addressName: map["address_name"],
        addressNumber: map["address_number"],
        cep: map["cep"],
        city: map["city"],
        createdAt: map["created_at"],
        formatedAddress: map["formated_address"],
        id: map["id"],
        latitude: map["latitude"],
        longitude: map["longitude"],
        main: map["main"],
        neighborhood: map["neighborhood"],
        state: map["state"],
        status: map["status"],
        withoutComplement: map["without_complement"],
      );

  factory Address.fromGeoResult(GeocodingResult geoRes, Address? address) {
    Address _address = Address();

    if (address != null) {
      _address = address;
    }

    _address.formatedAddress = geoRes.formattedAddress;

    // if (geoRes.geometry != null && geoRes.geometry?.location != null) {
    //   _address.latitude = geoRes.geometry!.location?.lat;
    //   _address.latitude = geoRes.geometry!.location?.lng;
    // }
    if (geoRes.addressComponents != null) {
      for (AddressComponent component in geoRes.addressComponents!) {
        // print("types: ${component.types}, name: ${component.longName} ");
        if (component.types != null) {
          if (component.types!.contains("administrative_area_level_1")) {
            _address.state = component.longName;
          } else if (component.types!.contains("administrative_area_level_2")) {
            _address.city = component.longName;
          } else if (component.types!.contains("administrative_area_level_4")) {
            _address.city = component.longName;
          } else if (component.types!.contains("sublocality_level_2")) {
            _address.neighborhood = component.longName;
          } else if (component.types!.contains("sublocality_level_3")) {
            _address.neighborhood = component.longName;
          } else if (!component.types!.contains("sublocality_level_3")) {
            _address.neighborhood = "";
          } else if (component.types!.contains("postal_code")) {
            _address.cep = component.longName;
          }
        }
      }
    }

    // print("_address: ${_address.toJson()}");

    return _address;
    // return Address(
    //   addressComplement:,
    //   addressName:,
    //   addressNumber:,
    //   cep:,
    //   city:,
    //   createdAt:,
    //   formatedAddress:,
    //   id:,
    //   latitude:,
    //   longitude:,
    //   main:,
    //   neighborhood:,
    //   state:,
    //   status:,
    //   withoutComplement:,
    // );
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getAddressSnap() =>
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("addresses")
          .doc(id)
          .snapshots();
}

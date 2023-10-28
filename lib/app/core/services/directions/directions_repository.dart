import 'package:delivery_customer/app/core/models/directions_model.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:delivery_customer/app/constants/.env.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class DirectionRepository {
  static const _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio _dio;

  DirectionRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(_baseUrl, queryParameters: {
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      "key": googleAPIKey,
    });

    if (response.statusCode == 200) {
      print('response.data: ${response.data}');
      return Directions.fromMap(response.data);
    }
    return null;
  }

  // Future<DirectionsOSMap?> getDirectionsOSMap({
  //   required MapLatLng origin,
  //   required MapLatLng destination,
  // }) async {
  //   final response = await _dio.get(_baseUrl, queryParameters: {
  //     "origin": "${origin.latitude},${origin.longitude}",
  //     "destination": "${destination.latitude},${destination.longitude}",
  //     "key": googleAPIKey,
  //   });

  //   // print('response.statusCode: ${response.statusCode}');

  //   if (response.statusCode == 200) {
  //   // print('getDirectionsOSMap response: ${response.data}');
  //     return DirectionsOSMap.fromGoogleMap(response.data);
  //   }
  //   return null;
  // }
}

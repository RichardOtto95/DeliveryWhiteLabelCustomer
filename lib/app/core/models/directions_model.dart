import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;
  final int distanceValue;
  final int durationValue;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // print("map: $map");
    // if ((map['routes'] as List).isEmpty) return null;

    final data = Map<String, dynamic>.from(map["routes"][0]);
    // print('directions data: $data');;

    final northeast = data["bounds"]["northeast"];
    final southwest = data["bounds"]["southwest"];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast["lat"], northeast["lng"]),
      southwest: LatLng(southwest["lat"], southwest["lng"]),
    );

    String distance = "";
    String duration = "";

    int durationValue = 0;
    int distanceValue = 0;

    if ((data["legs"] as List).isNotEmpty) {
      final leg = data["legs"][0];
      distance = leg["distance"]["text"];
      duration = leg["duration"]["text"];
      durationValue = leg["duration"]["value"];
      distanceValue = leg["distance"]["value"];
    }
    return Directions(
      bounds: bounds,
      polylinePoints:
          PolylinePoints().decodePolyline(data["overview_polyline"]["points"]),
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue,
    );
  }
}

class DirectionsOSMap {
  final MapLatLngBounds bounds;
  final String totalDistance;
  final String totalDuration;
  final num distanceValue;
  final num durationValue;
  final List<MapLatLng> polyPoints;

  const DirectionsOSMap({
    required this.bounds,
    required this.polyPoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory DirectionsOSMap.fromOSMap({
    required MapLatLng northeast,
    required MapLatLng southwest,
    required String distance,
    required String duration,
    required num distanceValue,
    required num durationValue,
    required List<MapLatLng> polyPoints,
  }) {
    MapLatLngBounds bounds = MapLatLngBounds(
      northeast, 
      southwest,
    );

    return DirectionsOSMap(
      bounds: bounds,
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue, 
      polyPoints: polyPoints,
    );
  }
}

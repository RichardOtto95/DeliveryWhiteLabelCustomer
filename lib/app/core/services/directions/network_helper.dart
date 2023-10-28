import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:convert';

import '../../models/directions_model.dart';

class NetworkHelper{
  NetworkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  final String url ='https://api.openrouteservice.org/v2/directions/';
  final String apiKey = '5b3ce3597851110001cf62480554d2fded59421a8a6a8f5c1a04099f';
  final String pathParam = 'driving-car';// Change it if you want
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future<Map> getData() async{
    // print('network_helper getData');
    http.Response response = await http.get(Uri.parse('$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));
    
    // print('http.Response: $response');
    // print('http.Response.statusCode: ${response.statusCode}');
    if(response.statusCode == 200) {
      String data = response.body;

      var responseJson = jsonDecode(data);
      print('responseJson: ${responseJson['features'][0]['properties']['summary']['duration']}');
      print('responseJson: ${responseJson['features'][0]['properties']['summary']['distance']}');
      String distance = "";
      String duration = "";

      num durationSeconds = responseJson['features'][0]['properties']['summary']['duration'];
      num distanceM = responseJson['features'][0]['properties']['summary']['distance'];
      

      if(durationSeconds > 60){
        num durationMinutes = durationSeconds / 60;

        if(durationMinutes < 60){
          duration = durationMinutes.toStringAsFixed(0) + "m";
        } else {
          num durationHour = durationMinutes / 60;

          duration = durationHour.toStringAsFixed(0) + "h";
        }
      } else {
        duration = durationSeconds.toStringAsFixed(0) + "s";
      }

      if(distanceM > 1.000){
        num distanceKm = distanceM / 1.000;
        distance = distanceKm.toStringAsFixed(1) + "Km";
      } else {
        if(distanceM < 10){
          distance = "Chegou";
        } else {
          distance = distanceM.toStringAsFixed(1) + "m";
        }
      }
      
      print('responseJson: ${responseJson['features'][0]['bbox']}');

      List<dynamic> bbox = responseJson['features'][0]['bbox'];      
      MapLatLng northeast = MapLatLng(bbox[3], bbox[2]);
      MapLatLng southwest = MapLatLng(bbox[1], bbox[0]);      

      List<dynamic> coordinates = responseJson['features'][0]['geometry']['coordinates'];

      LineString ls = LineString(coordinates);

      List<MapLatLng> _polyPoints = [];

      for (int i = 0; i < ls.lineString.length; i++) {
        _polyPoints.add(MapLatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      return {
        "status": "SUCCESS",
        "error-code": null,
        "direction": DirectionsOSMap.fromOSMap(
          distance: distance,
          distanceValue: distanceM,
          duration: duration,
          durationValue: durationSeconds,
          northeast: northeast,
          southwest: southwest,
          polyPoints: _polyPoints
        ),
      };
    }
    else{
      print(response.statusCode);
      return {
        "status": "FAILED",
        "error-code": response.statusCode,
        "direction": null,
      };
    }
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
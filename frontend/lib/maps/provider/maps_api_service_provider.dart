import 'dart:convert';

import 'package:frontend/maps/model/maps_place_from_coordinates_model.dart';
import 'package:http/http.dart' as http;

import '../model/maps_auto_complete_model.dart';
import '../model/maps_get_coordinates_from_place_id_model.dart';

class MapsApiServiceProvider {
  Future<MapsPlaceFromCoordinatesModel> placeFromCoordinates(double lat, double lng, String apiKey) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MapsPlaceFromCoordinatesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }
  }

  Future<MapsAutoCompleteModel> autoComplete(String placeName, String apiKey) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$apiKey&input=$placeName');
    final response = await http.get(url);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return MapsAutoCompleteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }

  }

  Future<MapsGetCoordinatesFromPlaceIdModel> getCoordinatesFromPlaceId(String placeId, String apiKey) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&placeid=$placeId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MapsGetCoordinatesFromPlaceIdModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }

  }

}


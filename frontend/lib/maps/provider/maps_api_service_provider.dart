import 'dart:convert';

import 'package:frontend/maps/model/maps_place_from_coordinates_model.dart';
import 'package:http/http.dart' as http;

import '../model/maps_auto_complete_model.dart';
import '../model/maps_get_coordinates_from_place_id_model.dart';

enum Language {
  korean('ko'),
  english('en'),
  japanese('ja'),
  chinese('zh');

  const Language(this.code);
  final String code;
}



class MapsApiServiceProvider {

  Language defaultLanguage = Language.korean;

  void setLanguage(Language language) {
    defaultLanguage = language;
  }

  String get currentLanguage => defaultLanguage.code;

  Future<MapsPlaceFromCoordinatesModel> placeFromCoordinates(double lat, double lng, String apiKey, Language language) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey&language=${language.code}&region=kr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MapsPlaceFromCoordinatesModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }
  }

  Future<MapsAutoCompleteModel> autoComplete(String placeName, String apiKey, Language language) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$apiKey&input=$placeName&language=${language.code}&region=kr');
    final response = await http.get(url);
    print("1 $response");

    if (response.statusCode == 200) {
      return MapsAutoCompleteModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }

  }

  Future<MapsGetCoordinatesFromPlaceIdModel> getCoordinatesFromPlaceId(String placeId, String apiKey, Language language) async {
    final Uri url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?key=$apiKey&placeid=$placeId&language=${language.code}&region=kr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("2 $response");
      return MapsGetCoordinatesFromPlaceIdModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('API ERROR');
    }

  }

}


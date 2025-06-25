import 'package:flutter/services.dart';

class Config {
  static const platform = MethodChannel('com.bapful.onbapsang/config');

  static Future<String> getGoogleMapsApiKey() async {
    try {
      final String result = await platform.invokeMethod('getGoogleMapsApiKey');
      return result;
    } catch (e) {
      return '';
    }
  }
}
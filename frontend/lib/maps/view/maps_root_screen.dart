import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'maps_screen.dart';

class MapsRootScreen extends StatefulWidget {
  const MapsRootScreen({super.key});

  @override
  State<MapsRootScreen> createState() => _MapsRootScreenState();
}

String apiKey = '';

class _MapsRootScreenState extends State<MapsRootScreen> {
  double positionLat = 0.0;
  double positionLng = 0.0;

  Future<void> _loadApiKey() async {
    final accessApiKey = await Config.getGoogleMapsApiKey();
    setState(() {
      apiKey = accessApiKey;
    });

  }

  @override
  void initState() {
    super.initState();
    _loadApiKey();
    _permission();
  }

  void _permission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;

    if (requestStatus.isGranted) {
      // 위치 서비스 켜졌는지 확인
      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnabled) {
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          positionLat = position.latitude;
          positionLng = position.longitude;
        });
      } else {
      }
    } else if (Platform.isIOS && status.isLimited) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        positionLat = position.latitude;
        positionLng = position.longitude;
      });
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      openAppSettings();
    } else if (status.isDenied) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      // child: MapsLocationScreen(apiKey: apiKey),
      child: MapScreen(lng: positionLng, lat: positionLat, isFirstLoading: false,),
    );
  }
}

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

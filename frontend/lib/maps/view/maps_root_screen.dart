import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'maps_screen.dart';

class MapsRootScreen extends StatefulWidget {
  const MapsRootScreen({super.key});

  @override
  State<MapsRootScreen> createState() => _MapsRootScreenState();
}

class _MapsRootScreenState extends State<MapsRootScreen> {
  double? positionLat;
  double? positionLng;
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestLocationAndGetPosition();
  }

  Future<void> _requestLocationAndGetPosition() async {
    try {
      // 1. 권한 요청
      var requestStatus = await Permission.location.request();
      var status = await Permission.location.status;

      if (requestStatus.isGranted || (Platform.isIOS && status.isLimited)) {
        // 2. 위치 서비스 확인
        final isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

        if (!isLocationServiceEnabled) {
          throw Exception("map.no_auth".tr());
        }

        // 3. 플랫폼별 위치 설정
        LocationSettings locationSettings;

        if (Platform.isAndroid) {
          locationSettings = AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
            forceLocationManager: true,
            intervalDuration: const Duration(seconds: 10),
          );
        } else if (Platform.isIOS) {
          locationSettings = AppleSettings(
            accuracy: LocationAccuracy.high,
            activityType: ActivityType.other,
            distanceFilter: 0,
            pauseLocationUpdatesAutomatically: true,
            showBackgroundLocationIndicator: false,
          );
        } else {
          locationSettings = const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          );
        }

        // 4. 현재 위치 가져오기
        final position = await Geolocator.getCurrentPosition(
          locationSettings: locationSettings,
        );

        if (mounted) {
          setState(() {
            positionLat = position.latitude;
            positionLng = position.longitude;
            isLoading = false;
          });
        }
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        openAppSettings();
        throw Exception("map.auth_hint".tr());
      } else {
        throw Exception("map.auth_deny".tr());
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = '${"map.error_message".tr()}: $error';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultLayout(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("map.loading_message".tr()),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return DefaultLayout(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _requestLocationAndGetPosition();
                },
                child: Text("common.again".tr()),
              ),
            ],
          ),
        ),
      );
    }

    return MapScreen(
      lat: positionLat!,
      lng: positionLng!,
      isFirstLoading: false,
    );
  }
}
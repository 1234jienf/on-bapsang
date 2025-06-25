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
          throw Exception('위치 서비스가 비활성화되어 있습니다.');
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
        throw Exception('위치 권한이 필요합니다. 설정에서 권한을 허용해주세요.');
      } else {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = '현재 위치를 가져올 수 없습니다: $error';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DefaultLayout(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('위치 정보를 가져오는 중...'),
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
                child: const Text('다시 시도'),
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
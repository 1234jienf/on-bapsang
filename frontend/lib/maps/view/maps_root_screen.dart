import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'maps_screen.dart';

class MapsRootScreen extends StatefulWidget {
  const MapsRootScreen({super.key});

  @override
  State<MapsRootScreen> createState() => _MapsRootScreenState();
}

class _MapsRootScreenState extends State<MapsRootScreen>
    with WidgetsBindingObserver {
  double? positionLat;
  double? positionLng;
  String? errorMessage;
  bool isLoading = true;
  bool isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestLocationAndGetPosition();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isPermissionDenied) {
      _recheckPermission();
    }
  }

  Future<void> _requestLocationAndGetPosition() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
        isPermissionDenied = false;
      });

      // 1. 권한 요청
      var requestStatus = await Permission.location.request();
      var status = await Permission.location.status;

      if (requestStatus.isGranted || (Platform.isIOS && status.isLimited)) {
        await _getCurrentLocation();
      } else if (status.isPermanentlyDenied || status.isRestricted) {
        _showPermissionDeniedDialog(isPermanent: true);
        return;
      } else {
        _showPermissionDeniedDialog(isPermanent: false);
        return;
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

  Future<void> _getCurrentLocation() async {
    try {
      // 2. 위치 서비스 확인
      final isLocationServiceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!isLocationServiceEnabled) {
        _showPermissionDeniedDialog(isPermanent: false);
        return;
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
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = '${"map.error_message".tr()}: $error';
          isLoading = false;
        });
      }
    }
  }

  void _showPermissionDeniedDialog({required bool isPermanent}) {
    if (mounted) {
      setState(() {
        isLoading = false;
        isPermissionDenied = true;
        errorMessage = null;
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) =>
          AlertDialog(
            title: Text('위치 권한 필요'),
            content: Text(
              isPermanent
                  ? '위치 서비스를 사용하려면 설정에서 위치 권한을 허용해주세요.'
                  : '위치 서비스를 사용하려면 위치 권한이 필요합니다.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                },
                child: Text('취소'),
              ),
              TextButton(
                onPressed: () async {
                  context.pop();
                  if (isPermanent) {
                    // 설정 화면으로 이동
                    await openAppSettings();
                  } else {
                    // 권한 다시 요청
                    _requestLocationAndGetPosition();
                  }
                },
                child: Text(isPermanent ? '설정으로 이동' : '다시 시도'),
              ),
            ],
          ),
    );
  }

  // 설정에서 돌아온 후 권한 재확인
  Future<void> _recheckPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted || (Platform.isIOS && status.isLimited)) {
      _requestLocationAndGetPosition();
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
              Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
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

    if (positionLat != null && positionLng != null) {
      return MapScreen(
        lat: positionLat!,
        lng: positionLng!,
        isFirstLoading: false,
      );
    }

    return DefaultLayout(child: Center(child: Text('Loading...')));
  }
}

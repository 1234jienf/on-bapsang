import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/maps/model/maps_address_parser.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/layout/default_layout.dart';
import '../common/config.dart';
import '../model/maps_place_from_coordinates_model.dart';
import '../provider/maps_api_service_provider.dart';
import 'maps_location_screen.dart';

class MapScreen extends StatefulWidget {
  static String get routeName => 'MapScreen';
  final double lat;
  final double lng;
  final bool isFirstLoading;

  const MapScreen({
    super.key,
    required this.lat,
    required this.lng,
    required this.isFirstLoading,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late double defaultLat;
  late double defaultLng;
  Timer? _moveDebounce;
  Timer? _addressDebounce;
  String apiKey = '';
  bool isLoadingAddress = false;

  MapsPlaceFromCoordinatesModel placeFromCoordinates = MapsPlaceFromCoordinatesModel();

  Future<void> _loadApiKey() async {
    final accessApiKey = await Config.getGoogleMapsApiKey();
    setState(() {
      apiKey = accessApiKey;
    });
  }

  Future<void> getAddress() async {
    if (apiKey.isEmpty) return;

    setState(() {
      isLoadingAddress = true;
    });

    try {
      final value = await MapsApiServiceProvider().placeFromCoordinates(
        defaultLat,
        defaultLng,
        apiKey,
        Language.korean
      );

      if (!mounted) return;

      setState(() {
        placeFromCoordinates = value;
        isLoadingAddress = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    defaultLat = widget.lat;
    defaultLng = widget.lng;

    _loadApiKey().then((_) {
      getAddress();
    });
  }

  @override
  void dispose() {
    _moveDebounce?.cancel();
    _addressDebounce?.cancel();
    super.dispose();
  }

  void _debouncedGetAddress() {
    _addressDebounce?.cancel();
    _addressDebounce = Timer(const Duration(milliseconds: 500), () {
      getAddress();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (placeFromCoordinates.results?[0].formattedAddress == null ) return SizedBox();
    MapsAddressParser.parseAddress(placeFromCoordinates.results![0].formattedAddress!);
    // print('Placecoordinates : ${placeFromCoordinates.results?[0].formattedAddress}');
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("주변"),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: MapsLocationScreen(apiKey: apiKey),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.search_outlined, size: 30),
            ),
          ),
        ],
      ),
      child: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            minMaxZoomPreference: const MinMaxZoomPreference(14, 18),
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.lng),
              tilt: 0,
              zoom: 14.451926040649414,
            ),
            onCameraIdle: () {
              _debouncedGetAddress();
            },
            onCameraMove: (CameraPosition position) {
              _moveDebounce?.cancel();
              _moveDebounce = Timer(
                const Duration(milliseconds: 100),
                    () {
                  defaultLat = position.target.latitude;
                  defaultLng = position.target.longitude;
                },
              );
            },
          ),
          const Center(
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
          if (placeFromCoordinates.results?.isNotEmpty == true)
            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '선택된 위치',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        placeFromCoordinates.results?[0].formattedAddress ?? '주소를 가져오는 중...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isLoadingAddress)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 2,
                            child: LinearProgressIndicator(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
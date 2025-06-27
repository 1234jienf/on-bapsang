import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/maps/model/maps_address_parser.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/const/securetoken.dart';
import '../../common/layout/default_layout.dart';
import '../common/config.dart';
import '../model/maps_place_from_coordinates_model.dart';
import '../provider/maps_ahnsim_restaurant_finder_provider.dart';
import '../provider/maps_ahnsim_restaurant_provider.dart';
import '../provider/maps_api_service_provider.dart';
import 'maps_location_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
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
  ConsumerState<MapScreen> createState() => _ConsumerMapScreenState();
}

class _ConsumerMapScreenState extends ConsumerState<MapScreen> {
  late double defaultLat;
  late double defaultLng;
  Timer? _moveDebounce;
  Timer? _addressDebounce;
  String apiKey = '';
  bool isLoadingAddress = false;

  Set<Marker> markers = {};

  MapsPlaceFromCoordinatesModel placeFromCoordinates =
      MapsPlaceFromCoordinatesModel();

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
        Language.korean,
      );

      final userInfo = ref.read(secureStorageProvider);
      final lang = await userInfo.read(key: LANGUAGE_KEY);

      late final Language targetLang;

      switch (lang) {
        case 'JA':
          targetLang = Language.japanese;
          break;
        case 'ZH':
          targetLang = Language.chinese;
          break;
        case 'EN':
          targetLang = Language.english;
          break;
        default:
          targetLang = Language.korean;
          break;
      }

      if (targetLang != Language.korean) {
        final translateValue = await MapsApiServiceProvider()
            .placeFromCoordinates(
              defaultLat,
              defaultLng,
              apiKey,
              targetLang
            );
        transLateLocation(targetLang: targetLang, value: value, translateValue: translateValue);
      } else {
        transLateLocation(targetLang: targetLang, value: value);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  Future<void> transLateLocation({
    required Language targetLang,
    required value,
    translateValue,
  }) async {
    if (!mounted) return;
    if (value.results?[0].formattedAddress == null) return;

    final model = MapsAddressParser.parseAddress(
      value.results![0].formattedAddress!,
    );
    final state = ref.read(mapAhnsimRestaurantProvider);

    final response = await state.find(city: model.city, gu: model.gu);

    final data = response.data['rows'] as List<dynamic>;

    final finder = MapsAhnsimRestaurantFinderProvider().findNearbyRestaurants(
      currentLat: defaultLat,
      currentLng: defaultLng,
      restaurants: data,
    );

    _createRestaurantMarkers(finder);

    setState(() {
      if (targetLang == Language.korean) {
        placeFromCoordinates = value;
      } else {
        placeFromCoordinates = translateValue;
      }
      isLoadingAddress = false;
    });
  }

  void _createRestaurantMarkers(List<Map<String, dynamic>> restaurants) {
    Set<Marker> newMarkers = {};

    for (int i = 0; i < restaurants.length; i++) {
      final restaurant = restaurants[i];
      final lat = restaurant['latitude']?.toDouble() ?? 0.0;
      final lng = restaurant['longitude']?.toDouble() ?? 0.0;

      if (lat != 0.0 && lng != 0.0) {
        newMarkers.add(
          Marker(
            markerId: MarkerId('restaurant_${restaurant['seq']}'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(
              title: restaurant['name'] ?? '',
              snippet:
                  '${restaurant['gubunDetail']} • ${(restaurant['distance'] as double).toStringAsFixed(1)}km',
            ),
          ),
        );
      }
    }

    setState(() {
      markers = newMarkers;
    });
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
      if (mounted) {
        getAddress();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("common.map".tr()),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder:
                    (context) => SizedBox(
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
            markers: markers,
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
              _moveDebounce = Timer(const Duration(milliseconds: 100), () {
                defaultLat = position.target.latitude;
                defaultLng = position.target.longitude;
              });
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
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "map.selected_location".tr(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        placeFromCoordinates.results?[0].formattedAddress ??
                            "map.loading_message".tr(),
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

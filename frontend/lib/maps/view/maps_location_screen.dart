import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/maps/model/maps_auto_complete_model.dart';
import 'package:frontend/maps/provider/maps_api_service_provider.dart';
import 'package:go_router/go_router.dart';

import '../settings/location_permission_handler.dart';

class MapsLocationScreen extends StatefulWidget {
  final String apiKey;

  const MapsLocationScreen({super.key, required this.apiKey});

  @override
  State<MapsLocationScreen> createState() => _MapsLocationScreenState();
}

class _MapsLocationScreenState extends State<MapsLocationScreen> {
  TextEditingController searchPlaceController = TextEditingController();
  MapsAutoCompleteModel autoComplete = MapsAutoCompleteModel();
  bool isLoading = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 26.0,
            ),
            child: Row(
              children: [
                Text(
                  "map.search_title".tr(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // 검색 필드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _onSearchChanged,
              controller: searchPlaceController,
              decoration: InputDecoration(
                hintText: "map.search_hint".tr(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchPlaceController.text.trim().isNotEmpty
                        ? IconButton(
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.clear),
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),

          // 에러 메시지 표시
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red[600], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // 현재 위치 버튼
          if (searchPlaceController.text.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _getCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: Text("map.now_location".tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

          if (searchPlaceController.text.isNotEmpty)
            Expanded(child: _buildSearchResults()),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  void _onSearchChanged(String value) {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }

    if (value.trim().isEmpty) {
      setState(() {
        autoComplete = MapsAutoCompleteModel();
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (searchPlaceController.text.trim() == value.trim() && mounted) {
        _performSearch(value.trim());
      }
    });
  }

  void _performSearch(String query) async {
    try {
      final result = await MapsApiServiceProvider().autoComplete(
        query,
        widget.apiKey,
      );

      if (mounted) {
        setState(() {
          autoComplete = result;
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "common.error_message2".tr();
        });
      }
    }
  }

  void _clearSearch() {
    searchPlaceController.clear();
    setState(() {
      autoComplete = MapsAutoCompleteModel();
      isLoading = false;
      errorMessage = null;
    });
  }

  void _getCurrentLocation() async {
    final router = GoRouter.of(context);

    try {
      final position = await determinePosition();
      router.pop();
      router.pushNamed(
        'location',
        extra: {'lat': position.latitude, 'lng': position.longitude},
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          errorMessage = "map.location_get_error".tr();
        });
      }
    }
  }

  Widget _buildSearchResults() {
    final predictions = autoComplete.predictions;

    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (predictions == null || predictions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "map.no_result".tr(),
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: predictions.length,
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        final description = prediction.description ?? "map.no_location".tr();

        List<String> addressParts = description.split(',');
        String mainAddress =
            addressParts.isNotEmpty ? addressParts[0].trim() : description;
        String subAddress =
            addressParts.length > 1
                ? addressParts.sublist(1).join(',').trim()
                : '';

        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _selectLocation(prediction),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // 위치 아이콘
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            mainAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          if (subAddress.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              subAddress,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 화살표 아이콘
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectLocation(dynamic prediction) async {
    final router = GoRouter.of(context);

    try {
      final placeId = prediction?.placeId ?? "";
      if (placeId.isEmpty) {
        setState(() {
          errorMessage = "map.fail_get_location".tr();
        });
        return;
      }

      final result = await MapsApiServiceProvider().getCoordinatesFromPlaceId(
        placeId,
        widget.apiKey,
      );

      final lat = result.result?.geometry?.location?.lat;
      final lng = result.result?.geometry?.location?.lng;

      if (lat == null || lng == null) {
        setState(() {
          errorMessage = "map.fail_get_point".tr();
        });
        return;
      }

      router.pop();
      router.pushNamed('location', extra: {'lat': lat, 'lng': lng});

    } catch (error) {
      debugPrint('${"map.error_hint".tr()}: $error');
      if (mounted) {
        setState(() {
          errorMessage = "map.error_message".tr();
        });
      }
    }
  }

  @override
  void dispose() {
    searchPlaceController.dispose();
    super.dispose();
  }
}

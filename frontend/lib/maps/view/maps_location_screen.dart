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
                const Text(
                  '위치 검색',
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
              onChanged: (String value) {
                setState(() {});
                if (value.isNotEmpty) {
                  MapsApiServiceProvider()
                      .autoComplete(value, widget.apiKey)
                      .then((result) {
                        setState(() {
                          autoComplete = result;
                        });
                      });
                } else {
                  setState(() {
                    autoComplete = MapsAutoCompleteModel();
                  });
                }
              },
              controller: searchPlaceController,
              decoration: InputDecoration(
                hintText: '위치를 검색하세요',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    searchPlaceController.text.isNotEmpty
                        ? IconButton(
                          onPressed: () {
                            searchPlaceController.clear();
                            setState(() {
                              autoComplete = MapsAutoCompleteModel();
                            });
                          },
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
                  onPressed: () {
                    determinePosition()
                        .then((value) {
                          if (context.mounted) {
                            context.pop();
                            context.pushNamed(
                              'maps',
                              extra: {
                                'lat': value.latitude,
                                'lng': value.longitude,
                              },
                            );
                          }
                        })
                        .onError((error, stackTrace) {
                          print(error);
                        });
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text("현재 위치 사용"),
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

          // 검색 결과 리스트
          if (searchPlaceController.text.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: autoComplete.predictions?.length ?? 0,
                itemBuilder: (context, index) {
                  final prediction = autoComplete.predictions?[index];
                  final description = prediction?.description ?? '위치 정보 없음';

                  // 주소를 주요 부분과 상세 부분으로 분리
                  List<String> addressParts = description.split(',');
                  String mainAddress =
                      addressParts.isNotEmpty
                          ? addressParts[0].trim()
                          : description;
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
                        onTap: () {
                          MapsApiServiceProvider()
                              .getCoordinatesFromPlaceId(
                                prediction?.placeId ?? "",
                                widget.apiKey,
                              )
                              .then((value) {
                                if (context.mounted) {
                                  context.pop();
                                  context.pushNamed(
                                    'maps', extra: {'lat' : value.result?.geometry?.location?.lat, 'lng' : value.result?.geometry?.location?.lng}
                                  );
                                }
                              })
                              .onError((error, stackTrace) {
                                print(error);
                              });
                        },
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
                                    // 첫 번째 줄 - 주요 주소
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

                                    // 두 번째 줄 - 상세 주소 (있을 경우만)
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
              ),
            ),

          // 빈 공간 (키보드 대응)
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchPlaceController.dispose();
    super.dispose();
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/dio/dio.dart';

import '../../common/const/securetoken.dart';

final mapAhnsimRestaurantProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return MapsAhnsimRestaurantNotifier(dio);
});

class MapsAhnsimRestaurantNotifier {
  final Dio dio;

  MapsAhnsimRestaurantNotifier(this.dio);

  Future<Response> find({
    required String city,
    required String gu,
}) async {
    try {
      final response = await dio.get(
        '$ip/api/safe-restaurants',
        queryParameters: {
          'city' : city,
          'gu' : gu,
          'includeCoordinates': true,
        },
        options: Options(headers: {'accessToken' : 'true'}),
      );

      return response;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}
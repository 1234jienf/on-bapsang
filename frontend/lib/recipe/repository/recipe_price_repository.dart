import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'recipe_price_repository.g.dart';

final recipePriceRepositoryProvider = Provider<RecipePriceRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipePriceRepository(dio, baseUrl: '$ip/api/market/price');
});

@RestApi()
abstract class RecipePriceRepository {
  factory RecipePriceRepository(Dio dio, {String baseUrl}) = _RecipePriceRepository;

  @GET('/timeseries/{ingredientId}')
  @Headers({'accessToken': 'true'})
  Future<IngredientTimeSeries> getIngredientTimeSeries(@Path('ingredientId') int id);

  @GET('/region/{ingredientId}?yearMonth=202503')
  @Headers({'accessToken': 'true'})
  Future<IngredientRegion> getIngredientRegion(@Path('ingredientId') int id);
}
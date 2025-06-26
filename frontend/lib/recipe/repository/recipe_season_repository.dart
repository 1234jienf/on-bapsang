import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/recipe/model/recipe_season_ingredient_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/dio.dart';

part 'recipe_season_repository.g.dart';

final recipeSeasonRepositoryProvider = Provider<RecipeSeasonRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipeSeasonRepository(dio, baseUrl: '$ip/api/seasonal');
});

@RestApi()
abstract class RecipeSeasonRepository {
  factory RecipeSeasonRepository(Dio dio, {String baseUrl}) = _RecipeSeasonRepository;

  @GET('')
  @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<List<RecipeSeasonIngredientModel>> getSeasonIngredients(
    @Query('month') int month,
  );
}

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'recipe_repository.g.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipeRepository(dio, baseUrl: '$ip/api/recipe');
});

@RestApi()
abstract class RecipeRepository {
  factory RecipeRepository(Dio dio, {String baseUrl}) = _RecipeRepository;

  @GET('/foreign/{id}')
  @Headers({'accessToken': 'true'})
  Future<RecipeDetailModel> getRecipeDetail(@Path('id') int id);
}
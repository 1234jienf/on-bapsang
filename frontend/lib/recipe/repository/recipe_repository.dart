import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/model/recipe_pagination_params_model.dart';
import 'package:retrofit/dio.dart';
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

  @GET('/popular')
  // @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<List<RecipeModel>> getPopularRecipes();

  @GET('/recommend')
  // @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<List<RecipeModel>> getRecommendRecipes();

  @GET('/foreign/{id}')
  @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<RecipeDetailModel> getRecipeDetail(@Path('id') int id);

  @POST('/scrap/{id}')
  @Headers({'accessToken': 'true'})
  Future<void> recipeScrap(@Path('id') int id);

  @DELETE('/scrap/{id}')
  @Headers({'accessToken': 'true'})
  Future<void> cancelRecipeScrap(@Path('id') int id);

  @GET('/ingredient')
  // @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<CursorSimplePagination<RecipeModel>> paginate({
    @Queries() PaginationIntParams paginationIntParams = const PaginationWithNameParams(),
  });


  // 메인화면에서 페이지네이션 빼고 앞에꺼만 가져오기
  @GET('/ingredient')
  // @Headers({'accessToken': 'true'})
  @Extra({'useLang': true})
  Future<HttpResponse<dynamic>> getSeasonRecipeMainRaw(
      @Query('name') String ingredientName,
      @Query('page') int page,
      @Query('size') int size,
  );

}


Future<CursorStringPagination<RecipeModel>> getCategoryRecipesWithRawDio({
  required Dio dio,
  required String category,
  required int page,
  required int size,
}) async {
  try {
    final response = await dio.get(
      '$ip/api/recipe?category=$category&page=$page&size=$size',
      options: Options(headers: {'accessToken': 'true'}, extra:  {'useLang': true},),
    );

    print(response.data);

    return CursorStringPagination<RecipeModel>.fromJson(
      response.data,
          (json) {
        try {
          return RecipeModel.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('❌ RecipeModel 파싱 실패: $e\n⛳️ 데이터: $json');
          rethrow;
        }
      },
    );
  } catch (e, _) {
    print('API Error: $e');
    rethrow;
  }
}

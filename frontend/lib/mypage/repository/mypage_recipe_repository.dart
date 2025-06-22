import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/model/int/pagination_int_params.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/model/recipe_pagination_params_model.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'mypage_recipe_repository.g.dart';


final mypageRecipeRepositoryProvider = Provider<MypageRecipeRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MypageRecipeRepository(dio, baseUrl: '$ip/api/mypage');
});

@RestApi()
abstract class MypageRecipeRepository {
  factory MypageRecipeRepository(Dio dio, {String baseUrl}) = _MypageRecipeRepository;

  @GET('/scrap-recipes')
  @Headers({'accessToken': 'true'})
  Future<dynamic> paginate({
    @Queries() PaginationIntParams paginationIntParams = const PaginationWithNameParams(),
  });
}

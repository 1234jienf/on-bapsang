import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/repository/base_pagination_string_repository.dart';
import 'package:frontend/search/model/search_recipe_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../../common/model/string/cursor_pagination_string_model.dart';
import '../../common/model/string/pagination_string_params.dart';

part 'search_repository.g.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = SearchRepository(dio, baseUrl: '$ip/api/recipe');

  return repository;
});

@RestApi()
abstract class SearchRepository
    implements IBasePaginationStringRepository<SearchRecipeModel> {
  factory SearchRepository(Dio dio, {String baseUrl}) = _SearchRepository;

  @override
  @GET('/search')
  @Headers({'accessToken': 'true'})
  Future<CursorStringPagination<SearchRecipeModel>> paginate({
    @Queries()
    PaginationStringParams paginationStringParams =
        const PaginationStringParams(),
  });

  @POST('/foreign')
  @Headers({'accessToken': 'true'})
  Future<void> postRecipe({@Body() required Map<String, dynamic> body});
}

import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../model/search_keyword_model.dart';

part 'search_keyword_repository.g.dart';

final searchKeywordRepository = Provider<SearchKeywordRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository = SearchKeywordRepository(dio, baseUrl: '$ip/api/keywords');

  return repository;
});

@RestApi()
abstract class SearchKeywordRepository {
  factory SearchKeywordRepository(Dio dio, {String baseUrl}) = _SearchKeywordRepository;

  @GET('/popular')
  @Headers({'accessToken': 'true'})
  Future<SearchKeywordModel> fetchPopular();

  @GET('/recent')
  @Headers({'accessToken': 'true'})
  Future<SearchKeywordModel> fetchRecent();
}
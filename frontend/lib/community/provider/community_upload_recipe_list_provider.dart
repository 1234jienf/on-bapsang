import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/securetoken.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/community/model/community_upload_recipe_list_model.dart';

final tagSearchKeywordProvider = StateProvider<String>((ref) => '');

final communityUploadRecipeListProvider =
    FutureProvider.autoDispose.family<List<CommunityUploadRecipeListModel>, String>((
      ref,
      keyword,
    ) async {
      final dio = ref.watch(dioProvider);
      final storage = ref.watch(secureStorageProvider);
      final accessToken = await storage.read(key: ACCESS_TOKEN);

      final response = await dio.get(
        '$ip/api/community/posts/autocomplete',
        queryParameters: {'keyword': keyword},
        options: Options(headers: { 'Authorization': 'Bearer $accessToken'}, extra:  {'useLang': true})
      );

      final Map<String, dynamic> data = response.data;
      final List<dynamic> list = data['data'];

      return list
          .map((item) => CommunityUploadRecipeListModel.fromJson(item))
          .toList();
    });

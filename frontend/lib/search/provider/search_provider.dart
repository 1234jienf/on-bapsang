import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/pagination_string_provider.dart';
import 'package:frontend/search/model/search_recipe_model.dart';
import 'package:frontend/search/repository/search_repository.dart';

import '../../common/model/string/cursor_pagination_string_model.dart';

final searchProvider = StateNotifierProvider.family<SearchStateNotifier, CursorStringPaginationBase, String?>((ref, name) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchStateNotifier(repository: repository, name: name);
});

class SearchStateNotifier extends PaginationStringProvider<SearchRecipeModel, SearchRepository> {
  SearchStateNotifier({required super.repository, super.name});

}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/provider/search_normal_pagination_list_view_provider.dart';

import '../../common/model/string/cursor_pagination_normal_string_model.dart';
import '../repository/search_repository.dart';

final searchNormalListViewProvider = StateNotifierProvider.family<
  SearchNormalPaginationListViewProvider,
  CursorStringNormalPaginationBase,
  String?
>((ref, name) {
  final repo = ref.watch(searchRepositoryProvider);
  return SearchNormalPaginationListViewProvider(repository: repo, name: name);
});

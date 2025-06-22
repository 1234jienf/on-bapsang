import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/mypage/pagination/mypage_recipe_simple_pagination_notifier.dart';
import 'package:frontend/mypage/repository/mypage_recipe_repository.dart';

final mypageScrapRecipeProvider = StateNotifierProvider.family<
    MypageRecipeSimplePaginationNotifier,
    CursorSimplePaginationBase,
    String?>((ref, name) {
  final repository = ref.watch(mypageRecipeRepositoryProvider);
  return MypageRecipeSimplePaginationNotifier(repository: repository);
});
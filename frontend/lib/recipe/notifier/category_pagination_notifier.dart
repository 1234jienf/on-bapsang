import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';

class CategoryPaginationNotifier extends StateNotifier<CursorStringPaginationBase> {
  final RecipeRepository repository;
  final Dio dio;
  final String category;
  int currentPage = 0;
  bool isLoading = false;

  CategoryPaginationNotifier({
    required this.repository,
    required this.dio,
    required this.category,
  }) : super(CursorStringPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({bool fetchMore = false}) async {
    if (fetchMore && (state is CursorStringPaginationLoading)) {
      return;
    }

    final currentState = state;

    int page = 0;
    List<RecipeModel> existingData = [];

    if (fetchMore && currentState is CursorStringPagination<RecipeModel>) {
      if (!currentState.meta.hasMore) return;
      page = currentState.meta.currentPage + 1;
      existingData = currentState.data;
    }

    try {
      final response = await getCategoryRecipesWithRawDio(
        dio: dio,
        category: category,
        page: page,
        size: 10,
      );

      print('👀 상태 타입: ${state.runtimeType}');

      if (fetchMore) {
        state = response.copyWith(data: [...existingData, ...response.data]);
      } else {
        state = response;
      }
    } catch (e) {
      print('❌ 예외 발생: $e');
      state = CursorStringPaginationError(message: '불러오기 실패: $e');
    }
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/cursor_simple_pagination_mypage_extenstion.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/mypage/repository/mypage_recipe_repository.dart';
import 'package:frontend/recipe/model/recipe_pagination_params_model.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
class MypageRecipeSimplePaginationNotifier
    extends StateNotifier<CursorSimplePaginationBase> {
  final MypageRecipeRepository repository;

  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  MypageRecipeSimplePaginationNotifier({
    required this.repository,
  }) : super(CursorSimplePaginationLoading()) {
    paginate(); // 생성 시 첫 페이지 호출
  }

  Future<void> paginate({bool fetchMore = false}) async {
    if (_isLoading) return;
    if (!_hasMore && fetchMore) return;

    _isLoading = true;

    try {
      final raw = await repository.paginate(
        paginationIntParams: PaginationWithNameParams(
          page: fetchMore ? _currentPage + 1 : 0,
        ),
      );

      final result = CursorSimplePaginationMypage.fromMypageJson<RecipeModel>(
        raw as Map<String, dynamic>,
            (json) => RecipeModel.fromJson(json as Map<String, dynamic>),
      );

      final newPage = result.meta.currentPage;
      final hasMore = result.meta.hasMore;

      if (fetchMore && state is CursorSimplePagination<RecipeModel>) {
        final prev = (state as CursorSimplePagination<RecipeModel>).data;
        state = CursorSimplePagination<RecipeModel>(
          meta: result.meta,
          data: [...prev, ...result.data],
        );
      } else {
        state = result;
      }

      _currentPage = newPage;
      _hasMore = hasMore;
    } catch (e, stack) {
      print('❗ 에러 발생: $e');
      print('스택도 확인: $stack');
      state = CursorSimplePaginationError(message: '레시피 로딩 실패');
    } finally {
      _isLoading = false;
    }
  }

  void fetchMore() => paginate(fetchMore: true);
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/recipe/model/recipe_pagination_params_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';

class RecipeSimplePaginationNotifier<T>
    extends StateNotifier<CursorSimplePaginationBase> {
  final RecipeRepository repository;
  final String? name;

  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  RecipeSimplePaginationNotifier({
    required this.repository,
    this.name,
  }) : super(CursorSimplePaginationLoading()) {
    paginate(); // 생성 시 첫 페이지 호출
  }

  Future<void> paginate({bool fetchMore = false}) async {
    if (_isLoading) return;
    if (!_hasMore && fetchMore) return;

    _isLoading = true;

    try {
      final result = await repository.paginate(
        paginationIntParams: PaginationWithNameParams(
          page: fetchMore ? _currentPage + 1 : 0,
          name: name,
        ),
      ) as CursorSimplePagination<T>;

      final newPage = result.meta.currentPage;
      final hasMore = result.meta.hasMore;

      if (fetchMore && state is CursorSimplePagination<T>) {
        final prev = (state as CursorSimplePagination<T>).data;
        state = CursorSimplePagination<T>(
          meta: result.meta,
          data: [...prev, ...result.data],
        );
      } else {
        state = result;
      }

      _currentPage = newPage;
      _hasMore = hasMore;
    } catch (e) {
      state = CursorSimplePaginationError(message: '레시피 로딩 실패');
    } finally {
      _isLoading = false;
    }
  }

  void fetchMore() => paginate(fetchMore: true);
}

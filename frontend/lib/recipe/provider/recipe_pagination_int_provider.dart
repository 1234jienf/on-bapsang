import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/cursor_pagination_int_model.dart';
import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:frontend/common/repository/base_pagination_int_repository.dart';
import 'package:frontend/recipe/model/recipe_pagination_params_model.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 10,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}


class RecipePaginationProvider<T extends IModelWithIntId>
    extends StateNotifier<CursorIntPaginationBase> {
  final IBasePaginationIntRepository<T> repository;
  final String? ingredientName;
  final paginationThrottle = Throttle<_PaginationInfo>(
    const Duration(milliseconds: 500),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  RecipePaginationProvider({
    required this.repository,
    required this.ingredientName,
  }) : super(CursorIntPaginationLoading()) {
    paginate();

    paginationThrottle.values.listen((info) {
      _throttledPagination(info);
    });
  }

  Future<void> paginate({
    int fetchCount = 10,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(
      _PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
      ),
    );
  }

  Future<void> _throttledPagination(_PaginationInfo info) async {
    try {
      final fetchCount = info.fetchCount;
      final fetchMore = info.fetchMore;
      final forceRefetch = info.forceRefetch;

      if (state is CursorIntPagination && !forceRefetch) {
        final pState = state as CursorIntPagination;
        if (pState.data.last == true) return;
      }

      final isLoading = state is CursorIntPaginationLoading;
      final isRefetching = state is CursorIntPaginationRefetching;
      final isFetchingMore = state is CursorIntPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) return;

      PaginationWithNameParams params;

      if (fetchMore) {
        final pState = state as CursorIntPagination<T>;
        state = CursorIntPaginationFetchingMore<T>(
          status: pState.status,
          message: pState.message,
          data: pState.data,
        );

        params = PaginationWithNameParams(
          name: ingredientName,
          page: pState.data.pageable!.pageNumber + 1,
          size: fetchCount,
        );
      } else {
        if (state is CursorIntPagination && !forceRefetch) {
          final pState = state as CursorIntPagination<T>;
          state = CursorIntPaginationRefetching<T>(
            status: pState.status,
            message: pState.message,
            data: pState.data,
          );
        } else {
          state = CursorIntPaginationLoading();
        }

        params = PaginationWithNameParams(
          name: ingredientName,
          page: 0,
          size: fetchCount,
        );
      }

      final resp = await repository.paginate(paginationIntParams: params);

      if (state is CursorIntPaginationFetchingMore<T>) {
        final pState = state as CursorIntPaginationFetchingMore<T>;
        state = resp.copyWith(
          data: resp.data.copyWith(
            content: [...pState.data.content, ...resp.data.content],
          ),
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      state = CursorIntPaginationError(message: '레시피 로딩 실패');
    }
  }
}

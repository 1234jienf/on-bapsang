import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../search/model/search_recipe_pagination_params.dart';
import '../model/string/cursor_pagination_string_model.dart';
import '../model/string/model_with_string_id.dart';
import '../model/string/pagination_string_params.dart';
import '../repository/base_pagination_string_repository.dart';

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

class PaginationStringProvider<
  T extends IModelWithStringId,
  U extends IBasePaginationStringRepository<T>
>
    extends StateNotifier<CursorStringPaginationBase> {
  final U repository;
  final String? name;

  final paginationThrottle = Throttle<_PaginationInfo>(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationStringProvider({required this.repository, this.name})
    : super(CursorStringPaginationLoading()) {
    paginate();

    // 3초의 시간이 지난 뒤 실행되는 함수
    paginationThrottle.values.listen((state) {
      _throttledPagination(state);
    });
  }

  Future<void> paginate({
    int fetchCount = 100,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(
      _PaginationInfo(
        forceRefetch: forceRefetch,
        fetchMore: fetchMore,
        fetchCount: fetchCount,
      ),
    );
  }


  _throttledPagination(_PaginationInfo info) async {
    final fetchCount = info.fetchCount;
    final fetchMore = info.fetchMore;
    final forceRefetch = info.forceRefetch;

    try {
      // 바로 반환하는 상황
      if (state is CursorStringPagination && !forceRefetch) {
        final pState = state as CursorStringPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 2) 로딩중 - fetchMore : true 일 때
      final isLoading = state is CursorStringPaginationLoading;
      final isRefetching = state is CursorStringPaginationRefetching;
      final isFetchingMore = state is CursorStringPaginationFetchingMore;

      // 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      dynamic paginationParams;

      if (name != null) {
        paginationParams = SearchRecipePaginationParams(food_name: name!, page: 0, size: fetchCount);
      }

      // fetchMore

      if (fetchMore) {
        final pState = state as CursorStringPagination<T>;

        state = CursorStringPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        if (pState.meta.hasMore) {
          if (name != null) {
            paginationParams = SearchRecipePaginationParams(
              page: pState.meta.currentPage + 1,
              food_name: name!,
            );
          } else {
            paginationParams = PaginationStringParams(
              page: pState.meta.currentPage + 1,
            );
          }
        }

      } else {
        if (state is CursorStringPagination && !forceRefetch) {
          final pState = state as CursorStringPagination<T>;

          // 리패치 진행
          state = CursorStringPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorStringPaginationLoading();
        }
      }
        final resp = await repository.paginate(
          paginationStringParams: paginationParams,
        );


      if (state is CursorStringPaginationFetchingMore<T>) {
        final pState = state as CursorStringPaginationFetchingMore<T>;

        // 기존 데이터 + 새로운 데이터 추가.
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorStringPaginationError(message: name!);
    }
  }
}

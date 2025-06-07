import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/cursor_pagination_model.dart';
import '../model/model_with_id.dart';
import '../model/pagination_params.dart';
import '../repository/base_pagination_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 20,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class PaginationProvider<
T extends IModelWithId,
U extends IBasePaginationRepository<T>
>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle<_PaginationInfo>(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationProvider({required this.repository})
      : super(CursorPaginationLoading()) {
    paginate();

    // 3초의 시간이 지난 뒤 실행되는 함수
    paginationThrottle.values.listen((state) {
      _throttledPagination(state);
    });
  }

  Future<void> paginate({
    int fetchCount = 20,
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
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.isLast) {
          return;
        }
      }

      // 2) 로딩중 - fetchMore : true 일 때
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      // fetchMore

      if (fetchMore) {
        final pState = state as CursorPagination<T>;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        if (pState.data.last.stringId != null) {
          paginationParams = paginationParams.copyWith(
            stringAfterId: pState.data.last.stringId,
          );
        } else if (pState.data.last.intId != null) {
          paginationParams = paginationParams.copyWith(
            intAfterId: pState.data.last.intId,
          );
        }

      }
      else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          // 리패치 진행
          state = CursorPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore<T>) {
        final pState = state as CursorPaginationFetchingMore<T>;

        // 기존 데이터 + 새로운 데이터 추가.
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/int/cursor_pagination_int_model.dart';
import '../model/string/cursor_pagination_string_model.dart';
import '../model/string/model_with_string_id.dart';
import '../model/string/pagination_string_params.dart';
import '../repository/base_pagination_string_repository.dart';

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

class PaginationStringProvider<
T extends IModelWithStringId,
U extends IBasePaginationStringRepository<T>
>
    extends StateNotifier<CursorStringPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle<_PaginationInfo>(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  PaginationStringProvider({required this.repository})
      : super(CursorStringPaginationLoading()) {
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
      if (state is CursorIntPagination && !forceRefetch) {
        final pState = state as CursorIntPagination;
        if (!pState.meta.isLast) {
          return;
        }
      }

      // 2) 로딩중 - fetchMore : true 일 때
      final isLoading = state is CursorStringPaginationLoading;
      final isRefetching = state is CursorIntPaginationRefetching;
      final isFetchingMore = state is CursorIntPaginationFetchingMore;

      // 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationStringParams paginationParams = PaginationStringParams(count: fetchCount);

      // fetchMore

      if (fetchMore) {
        final pState = state as CursorStringPagination<T>;

        state = CursorStringPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        // if (pState.data.last.stringId != null) {
        //   paginationParams = paginationParams.copyWith(
        //     stringAfterId: pState.data.last.stringId,
        //   );
        // } else if (pState.data.last.id != null) {
        //   paginationParams = paginationParams.copyWith(
        //     intAfterId: pState.data.last.id,
        //   );
        // }

      }
      else {
        if (state is CursorStringPagination && !forceRefetch) {
          final pState = state as CursorStringPagination<T>;

          // 리패치 진행
          state = CursorStringPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        else {
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
      state = CursorStringPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}

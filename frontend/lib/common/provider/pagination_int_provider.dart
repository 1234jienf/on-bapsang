import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/cursor_pagination_int_model.dart';
import 'package:frontend/common/repository/base_pagination_int_repository.dart';
import '../model/int/model_with_id.dart';
import '../model/int/pagination_int_params.dart';

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

class PaginationIntProvider<
T extends IModelWithIntId,
U extends IBasePaginationIntRepository<T>
>
    extends StateNotifier<CursorIntPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle<_PaginationInfo>(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );



  PaginationIntProvider({required this.repository})
      : super(CursorIntPaginationLoading()) {
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
        if (!pState.meta.last) {
          return;
        }
      }

      // 2) 로딩중 - fetchMore : true 일 때
      final isLoading = state is CursorIntPaginationLoading;
      final isRefetching = state is CursorIntPaginationRefetching;
      final isFetchingMore = state is CursorIntPaginationFetchingMore;

      // 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      PaginationIntParams paginationIntParams = PaginationIntParams(count: fetchCount);

      // fetchMore
      if (fetchMore) {
        final pState = state as CursorIntPagination<T>;

        state = CursorIntPaginationFetchingMore(
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
        if (state is CursorIntPagination && !forceRefetch) {
          final pState = state as CursorIntPagination<T>;

          // 리패치 진행
          state = CursorIntPaginationRefetching<T>(
            meta: pState.meta,
            data: pState.data,
          );
        }
        else {
          state = CursorIntPaginationLoading();
        }
      }

      final wrapper = await repository.paginate(
        paginationIntParams: paginationIntParams,
      );
      final resp = wrapper.result;

      if (state is CursorIntPaginationFetchingMore<T>) {
        final pState = state as CursorIntPaginationFetchingMore<T>;

        // 기존 데이터 + 새로운 데이터 추가.
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorIntPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}

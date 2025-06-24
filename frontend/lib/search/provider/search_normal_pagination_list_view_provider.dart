import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/model/search_recipe_normal_list_view.dart';
import 'package:frontend/search/model/search_recipe_model.dart';
import '../../common/model/string/cursor_pagination_normal_string_model.dart';
import '../../common/model/string/pagination_string_params.dart';
import '../repository/search_repository.dart';

class _PaginationInfo {
  final int fetchCount;
  final bool fetchMore;
  final bool forceRefetch;

  _PaginationInfo({
    this.fetchCount = 100,
    this.fetchMore = false,
    this.forceRefetch = false,
  });
}

class SearchNormalPaginationListViewProvider
    extends StateNotifier<CursorStringNormalPaginationBase> {
  final SearchRepository repository;
  final String? name;

  final paginationThrottle = Throttle<_PaginationInfo>(
    Duration(seconds: 3),
    initialValue: _PaginationInfo(),
    checkEquality: false,
  );

  SearchNormalPaginationListViewProvider({required this.repository, this.name})
    : super(CursorStringNormalPaginationLoading()) {
    paginateGET();

    paginationThrottle.values.listen((state) {
      _throttledPagination(state);
    });
  }

  Future<void> paginateGET({
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
      if (state is CursorPaginationNormalStringModel && !forceRefetch) {
        final pState = state as CursorPaginationNormalStringModel;
        if (!pState.meta.hasMore) {
          return;
        }
      }


      final isLoading = state is CursorStringNormalPaginationLoading;
      final isRefetching = state is CursorStringNormalPaginationRefetching;
      final isFetchingMore = state is CursorStringNormalPaginationFetchingMore;



      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }



      dynamic paginationParams;

      if (name != null) {
        paginationParams = SearchRecipeNormalListView(
          page: 0,
          size: fetchCount,
          name: name!,
        );
      }

      if (fetchMore) {
        final pState =
            state as CursorPaginationNormalStringModel<SearchRecipeModel>;

        state = CursorStringNormalPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        if (pState.meta.hasMore) {
          if (name != null) {
            paginationParams = SearchRecipeNormalListView(
              page: pState.meta.currentPage + 1,
              name: name!,
            );
          } else {
            paginationParams = PaginationStringParams(
              page: pState.meta.currentPage + 1,
            );
          }
        }
      } else {
        print(state);
        if (state is CursorPaginationNormalStringModel && !forceRefetch) {
          final pState =
              state as CursorPaginationNormalStringModel<SearchRecipeModel>;

          state = CursorStringNormalPaginationRefetching<SearchRecipeModel>(
            meta: pState.meta,
            data: pState.data,
          );
        } else {
          state = CursorStringNormalPaginationLoading();
        }
      }

      final resp = await repository.paginateGET(
        paginationStringParams: paginationParams,
      );

      if (state
          is CursorStringNormalPaginationFetchingMore<SearchRecipeModel>) {
        final pState =
            state
                as CursorStringNormalPaginationFetchingMore<SearchRecipeModel>;

        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorStringNormalPaginationError(
        message: name ?? 'Unknown error',
      );
    }
  }
}

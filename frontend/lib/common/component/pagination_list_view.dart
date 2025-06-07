import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/model_with_id.dart';
import 'package:frontend/common/provider/pagination_provider.dart';

import '../model/cursor_pagination_model.dart';
import '../utils/pagination_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(BuildContext context, int index, T model);

class PaginationListView<T extends IModelWithId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProvider, CursorPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationListView({super.key, required this.provider, required this.itemBuilder});

  @override
  ConsumerState<PaginationListView> createState() => _PaginationListViewState();
}

class _PaginationListViewState<T extends IModelWithId> extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationUtils.paginate(controller: controller, provider: ref.read(widget.provider.notifier));
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);

    if (state is CursorPaginationLoading) {
      return Center(child: CircularProgressIndicator(),);
    }

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate();
        },
        child: ListView.separated(
          // 항상 스크롤이 되게
          physics: AlwaysScrollableScrollPhysics(),
          controller: controller,
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child:
                  cp is CursorPaginationFetchingMore
                      ? CircularProgressIndicator()
                      : Text('마지막 데이터입니다.'),
                ),
              );
            }

            final pItem = cp.data[index];

            // 파싱
            return widget.itemBuilder(context, index, pItem);
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 16.0);
          },
        ),
      ),
    );
  }
}

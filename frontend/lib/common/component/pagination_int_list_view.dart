import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/cursor_pagination_int_model.dart';
import '../model/int/model_with_id.dart';
import '../provider/pagination_int_provider.dart';
import '../utils/pagination_int_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithIntId> = Widget Function(BuildContext context, int index, T model);

class PaginationIntListView<T extends IModelWithIntId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationIntProvider, CursorIntPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationIntListView({super.key, required this.provider, required this.itemBuilder});

  @override
  ConsumerState<PaginationIntListView> createState() => _PaginationIntListViewState();
}

class _PaginationIntListViewState<T extends IModelWithIntId> extends ConsumerState<PaginationIntListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationIntUtils.paginate(controller: controller, provider: ref.read(widget.provider.notifier));
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

    if (state is CursorIntPaginationLoading) {
      return Center(child: CircularProgressIndicator(),);
    }

    // 에러 발생 상황
    if (state is CursorIntPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.message, textAlign: TextAlign.center),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              ref.read(widget.provider.notifier).paginate(forceRefetch: true);
            },
            child: Text('다시 시도'),
          ),
        ],
      );
    }

    final cp = state as CursorIntPagination<T>;

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
                  cp is CursorIntPaginationFetchingMore
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

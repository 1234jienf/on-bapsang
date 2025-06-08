import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:frontend/common/provider/pagination_string_provider.dart';
import 'package:frontend/common/utils/pagination_string_utils.dart';

import '../model/string/cursor_pagination_string_model.dart';

typedef PaginationWidgetBuilder<T extends IModelWithStringId> = Widget Function(BuildContext context, int index, T model);

class PaginationStringListView<T extends IModelWithStringId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationStringProvider, CursorStringPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;

  const PaginationStringListView({super.key, required this.provider, required this.itemBuilder});

  @override
  ConsumerState<PaginationStringListView> createState() => _PaginationStringListViewState();
}

class _PaginationStringListViewState<T extends IModelWithStringId> extends ConsumerState<PaginationStringListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    PaginationStringUtils.paginate(controller: controller, provider: ref.read(widget.provider.notifier));
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

    if (state is CursorStringPaginationLoading) {
      return Center(child: CircularProgressIndicator(),);
    }

    // 에러 발생 상황
    if (state is CursorStringPaginationError) {
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

    final cp = state as CursorStringPagination<T>;

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
                  cp is CursorStringPaginationFetchingMore
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

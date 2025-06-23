import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:frontend/common/provider/pagination_string_provider.dart';
import 'package:frontend/common/utils/pagination_string_utils.dart';

import '../model/string/cursor_pagination_string_model.dart';

typedef PaginationWidgetBuilder<T extends IModelWithStringId> =
    Widget Function(BuildContext context, int index, T model);

class PaginationStringListView<T extends IModelWithStringId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<
    PaginationStringProvider,
    CursorStringPaginationBase
  >
  provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final void Function(WidgetRef ref)? fetchFunction;
  final int fetchCount;

  const PaginationStringListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
    this.fetchFunction,
    required this.fetchCount
  });

  @override
  ConsumerState<PaginationStringListView> createState() =>
      _PaginationStringListViewState();
}

class _PaginationStringListViewState<T extends IModelWithStringId>
    extends ConsumerState<PaginationStringListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    final notifier = ref.read(widget.provider.notifier);
    PaginationStringUtils.paginate(controller: controller, provider: notifier);
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
      return Center(child: CircularProgressIndicator());
    }

    // 에러 발생 상황
    if (state is CursorStringPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '검색된 레시피가 없습니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    final cp = state as CursorStringPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.read(widget.provider.notifier).paginate(fetchCount: widget.fetchCount);
        },
        child: ListView.builder(
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: cp.data.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Center(child: CircularProgressIndicator());
            }

            final item = cp.data[index];
            return widget.itemBuilder(context, index, item);
          },
        ),
      ),
    );
  }
}

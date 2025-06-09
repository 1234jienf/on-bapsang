import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/int/cursor_pagination_int_model.dart';
import '../model/int/model_with_id.dart';
import '../provider/pagination_int_provider.dart';
import '../utils/pagination_int_utils.dart';

typedef PaginationWidgetBuilder<T extends IModelWithIntId> = Widget Function(BuildContext context, int index, T model);

class PaginationIntGridView<T extends IModelWithIntId> extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationIntProvider, CursorIntPaginationBase> provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final double childAspectRatio;

  const PaginationIntGridView({super.key, required this.provider, required this.itemBuilder, required this.childAspectRatio});

  @override
  ConsumerState<PaginationIntGridView> createState() => _PaginationIntGridViewState();
}

class _PaginationIntGridViewState<T extends IModelWithIntId> extends ConsumerState<PaginationIntGridView> {
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
        child: GridView.builder(
          controller: controller,
          physics: AlwaysScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: widget.childAspectRatio,
          ),
          itemCount: cp.data.content.length + 1,
          itemBuilder: (_, index) {
            if (index == cp.data.content.length) {
              return Center(child: CircularProgressIndicator());
            }

            final item = cp.data.content[index];
            return widget.itemBuilder(context, index, item);
          },
        ),
      ),
    );
  }
}

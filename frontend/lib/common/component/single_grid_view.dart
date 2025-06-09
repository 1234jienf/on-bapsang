import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/int/cursor_pagination_int_model.dart';
import '../provider/single_int_state_notifier.dart';

typedef SingleWidgetBuilder<T> = Widget Function(BuildContext context, int index, T model);

class SingleIntGridView<T> extends ConsumerStatefulWidget {
  final StateNotifierProvider<SingleIntStateNotifier<T>, AsyncValue<CursorIntPagination<T>>> provider;
  final SingleWidgetBuilder<T> itemBuilder;
  final double childAspectRatio;
  const SingleIntGridView({super.key, required this.itemBuilder, required this.provider, required this.childAspectRatio});

  @override
  ConsumerState<SingleIntGridView> createState() => _SingleIntGridViewState();
}

class _SingleIntGridViewState<T> extends ConsumerState<SingleIntGridView<T>> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {ref.read(widget.provider.notifier).fetchData();});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(widget.provider);

    print(items);

    return items.when(
      data: (item) => _buildGrid(item.data.content),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => SliverToBoxAdapter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('데이터를 불러올 수 없습니다'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ref.read(widget.provider.notifier).fetchData();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(List<T> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          childAspectRatio: widget.childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return widget.itemBuilder(context, index, items[index]);
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

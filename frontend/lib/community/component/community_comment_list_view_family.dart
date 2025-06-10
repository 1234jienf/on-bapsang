import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/model/int/single_int_one_page_model.dart';
import '../../common/provider/single_int_one_page_notifier.dart';

typedef SingleWidgetBuilder<T> =
    Widget Function(BuildContext context, int index, T model);

class CommunityCommentListViewFamily<T> extends ConsumerStatefulWidget {
  final StateNotifierProviderFamily<
    SingleIntOnePageNotifier<List<T>>,
    AsyncValue<SingleIntOnePageModel<List<T>>>,
    String
  >
  provider;
  final SingleWidgetBuilder<T> itemBuilder;
  final double childAspectRatio;
  final String id;

  const CommunityCommentListViewFamily({
    super.key,
    required this.id,
    required this.itemBuilder,
    required this.provider,
    required this.childAspectRatio,
  });

  @override
  ConsumerState<CommunityCommentListViewFamily<T>> createState() =>
      _CommunityCommentListViewFamilyState<T>();
}

class _CommunityCommentListViewFamilyState<T>
    extends ConsumerState<CommunityCommentListViewFamily<T>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(widget.provider(widget.id).notifier).fetchData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(widget.provider(widget.id));

    return items.when(
      data: (item) => _buildGrid(item.data),
      loading:
          () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('데이터를 불러올 수 없습니다'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(widget.provider(widget.id).notifier)
                          .fetchFunction();
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
    if (items.isEmpty) {
      return SliverToBoxAdapter(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 26.0, horizontal: 16.0),
        child: Center(child: Text('아직 댓글이 없습니다')),
      ));
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(childCount: items.length, (
          _,
          index,
        ) {
          return widget.itemBuilder(context, index, items[index]);
        }),
      ),
    );
  }
}

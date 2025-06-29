import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/string/cursor_pagination_normal_string_model.dart';
import 'package:frontend/common/model/string/model_with_string_id.dart';
import 'package:frontend/common/utils/pagination_string_utils.dart';
import 'package:go_router/go_router.dart';

import '../provider/search_keyword_provider.dart';
import '../provider/search_keyword_remian_provider.dart';
import '../provider/search_normal_pagination_list_view_provider.dart';
import '../provider/search_switch_component_provider.dart';

typedef PaginationWidgetBuilder<T extends IModelWithStringId> =
    Widget Function(BuildContext context, int index, T model);

class SearchNormalPaginationListView<T extends IModelWithStringId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<
    SearchNormalPaginationListViewProvider,
    CursorStringNormalPaginationBase
  >
  provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  final void Function(WidgetRef ref)? fetchFunction;
  final int fetchCount;

  const SearchNormalPaginationListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
    this.fetchFunction,
    required this.fetchCount,
  });

  @override
  ConsumerState<SearchNormalPaginationListView> createState() =>
      _PaginationStringListViewState();
}

class _PaginationStringListViewState<T extends IModelWithStringId>
    extends ConsumerState<SearchNormalPaginationListView> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    final notifier = ref.read(widget.provider.notifier);
    PaginationNormalUtils.paginateGET(
      controller: controller,
      provider: notifier,
    );
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

    if (state is CursorStringNormalPaginationLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 에러 발생 상황
    if (state is CursorStringNormalPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "search.no_result_recipe".tr(namedArgs: {"food": state.message}),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    ref.invalidate(searchKeywordProvider);
                    ref.read(searchKeywordRemainProvider.notifier).clear();
                    context.pop();
                  },
                  child: Text("search.no".tr(), style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  ref
                      .read(searchSwitchComponentProvider.notifier)
                      .switchComponent();
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  // 텍스트 가운데 정렬
                  child: Text(
                    "search.yes".tr(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    final cp = state as CursorPaginationNormalStringModel<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(widget.provider.notifier)
              .paginateGET(fetchCount: widget.fetchCount);
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

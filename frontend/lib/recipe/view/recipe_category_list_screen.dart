import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';
import 'package:frontend/recipe/component/recipe_list_component.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';

// 매핑용
const Map<String, String> koCategoryToKey = {
  '소고기':     'common.category.beef',
  '돼지고기':   'common.category.pork',
  '해물류':     'common.category.seafood',
  '달걀/유제품': 'common.category.egg_dairy',
  '채소류':     'common.category.vegetables',
  '쌀':        'common.category.rice',
  '곡류':       'common.category.grains',
  '밀가루':     'common.category.flour',
  '가공식품류':  'common.category.processed',
  '건어물류':    'common.category.dried',
  '기타':       'common.category.etc',
};

// 카테고리별로 레시피 리스트 보여줌
class RecipeCategoryListScreen extends ConsumerStatefulWidget {
  final String categoryName;
  static String get routeName => 'RecipeCategoryListScreen';
  const RecipeCategoryListScreen({super.key, required this.categoryName});

  @override
  ConsumerState<RecipeCategoryListScreen> createState() => _RecipeCategoryListScreenState();
}

class _RecipeCategoryListScreenState extends ConsumerState<RecipeCategoryListScreen> {
  final ScrollController controller = ScrollController();
  bool _isFetchingMore = false;

  late final ProviderSubscription<CursorStringPaginationBase> _sub;


  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);

    _sub = ref.listenManual<CursorStringPaginationBase>(
      categoryPaginationProvider(widget.categoryName),
          (prev, next) {
        _isFetchingMore =
            next is! CursorStringPagination && next is! CursorStringPaginationError;
      },
    );
  }

  void _scrollListener() {
    if (_isFetchingMore) return;

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 300) {
      _isFetchingMore = true;
      ref
          .read(categoryPaginationProvider(widget.categoryName).notifier)
          .paginate(fetchMore: true)
          .then((_) => _isFetchingMore = false);
    }
  }


  @override
  void dispose() {
    _sub.close();
    controller
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryPaginationProvider(widget.categoryName));

    final key = koCategoryToKey[widget.categoryName];
    final title = key != null ? key.tr() : widget.categoryName;

    return DefaultLayout(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: state is CursorStringPagination<RecipeModel>
            ? ListView.builder(
          controller: controller,
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            final recipe = state.data[index];
            return RecipeListComponent(recipeInfo: recipe);
          },
        )
            : state is CursorStringPaginationError
            ? Center(child: Text(state.message))
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

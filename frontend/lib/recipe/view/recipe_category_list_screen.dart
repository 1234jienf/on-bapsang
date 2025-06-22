import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/model/string/cursor_pagination_string_model.dart';
import 'package:frontend/recipe/component/recipe_list_component.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';

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

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);

    Future.microtask(() {
      ref.read(categoryPaginationProvider(widget.categoryName).notifier);
    });
  }

  void _scrollListener() {
    if (controller.position.pixels >= controller.position.maxScrollExtent - 300) {
      final notifier = ref.read(categoryPaginationProvider(widget.categoryName).notifier);
      notifier.paginate(fetchMore: true); // 내부에서 isLoading 처리됨
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryPaginationProvider(widget.categoryName));

    return DefaultLayout(
      appBar: AppBar(title: Text(widget.categoryName)),
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
    );
  }
}

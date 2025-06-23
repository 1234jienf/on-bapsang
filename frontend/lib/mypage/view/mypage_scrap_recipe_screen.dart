import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/common/model/int/simple_cursor_pagination_model.dart';
import 'package:frontend/mypage/provider/mypage_recipe_provider.dart';
import 'package:frontend/recipe/component/recipe_list_component.dart';
import 'package:frontend/recipe/model/recipe_model.dart';

class MypageScrapRecipeScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageScrapRecipeScreen';

  const MypageScrapRecipeScreen({super.key});

  @override
  ConsumerState<MypageScrapRecipeScreen> createState() => _MypageScrapRecipeScreenState();
}

class _MypageScrapRecipeScreenState extends ConsumerState<MypageScrapRecipeScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {
    final state = ref.read(mypageScrapRecipeProvider as ProviderListenable);

    if (controller.position.pixels >= controller.position.maxScrollExtent - 300) {
      if (state is CursorSimplePagination<RecipeModel>) {
        ref
          .read(mypageScrapRecipeProvider(null).notifier)
          .fetchMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mypageScrapRecipeProvider(null));

    List<Widget> recipeSection = [];

    if (state is CursorSimplePaginationLoading) {
      recipeSection.add(Center(child: CircularProgressIndicator()));
    } else if (state is CursorSimplePaginationError) {
      recipeSection.add(Text('에러: ${state.message}'));
    } else if (state is CursorSimplePagination<RecipeModel>) {
      final recipes = (state).data;
      if (recipes.isEmpty) {
        recipeSection.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Center(
              child: Text(
                '등록된 레시피가 없습니다!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      } else {
        recipeSection.addAll(
          recipes.map((recipe) => RecipeListComponent(recipeInfo: recipe)).toList(),
        );
      }
    }

    return DefaultLayout(
        appBar: AppBar(
          title: Text('스크랩한 레시피'),
          backgroundColor: Colors.white,
        ),
        child: ListView(
          controller: controller,
          children: recipeSection,
        ),
    );
  }
}

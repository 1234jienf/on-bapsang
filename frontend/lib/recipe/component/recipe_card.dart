import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/common/const/colors.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';

class RecipeCard extends ConsumerStatefulWidget {
  final List<RecipeModel> recipes;

  const RecipeCard({super.key, required this.recipes});

  @override
  ConsumerState<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends ConsumerState<RecipeCard> {
  late List<RecipeModel> recipeList;

  @override
  void initState() {
    super.initState();
    recipeList = List.from(widget.recipes);
  }

  @override
  void didUpdateWidget(covariant RecipeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.recipes.length != widget.recipes.length ||
        !_isSameList(oldWidget.recipes, widget.recipes)) {
      setState(() {
        recipeList = List.from(widget.recipes);
      });
    }
  }

  bool _isSameList(List<RecipeModel> a, List<RecipeModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  Future<void> toggleScrap(int index) async {
    final repo = ref.read(recipeRepositoryProvider);
    final recipe = recipeList[index];

    try {
      recipe.scrapped
          ? await repo.cancelRecipeScrap(recipe.id)
          : await repo.recipeScrap(recipe.id);

      setState(() {
        recipeList[index] = recipe.copyWith(scrapped: !recipe.scrapped);
      });
    } catch (_) {
      SnackBar(content: Text('레시피를 스크랩하는 과정에서 문제가 생겼습니다.'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recipeList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,          // 열 개수
        mainAxisSpacing: 24,        // 행 간 간격
        crossAxisSpacing: 12,       // 열 간 간격
        childAspectRatio: 4 / 3,    // 카드 가로:세로 비율
      ),
      itemBuilder: (_, index) {
        final recipe = recipeList[index];

        return InkWell(
          onTap: () => context.pushNamed(
            RecipeDetailScreen.routeName,
            pathParameters: {'id': recipe.id.toString()},
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          recipe.imageUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, progress) =>
                          progress == null
                              ? child
                              : Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, size: 40),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: IconButton(
                        iconSize: 24,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => toggleScrap(index),
                        icon: Icon(
                          recipe.scrapped
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: recipe.scrapped ? primaryColor : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                recipe.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.access_time, size: 14),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            recipe.time != 'nan' ? recipe.time : '-',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          'asset/img/chef_icon.png',
                          width: 14,
                          height: 14,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            recipe.difficulty,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Text(
              //   '${recipe.difficulty}, '
              //       '${recipe.portion != 'nan' ? recipe.portion : '-'}, '
              //       '${recipe.method}',
              //   maxLines: 1,
              //   overflow: TextOverflow.ellipsis,
              //   style: const TextStyle(fontSize: 10),
              // ),
            ],
          ),
        );
      },
    );
  }
}

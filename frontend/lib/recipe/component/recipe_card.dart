import 'package:flutter/material.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:frontend/recipe/model/recipe_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeCard extends ConsumerStatefulWidget {
  final List<RecipeModel> recipes;

  const RecipeCard({
    super.key,
    required this.recipes,
  });

  @override
  ConsumerState<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends ConsumerState<RecipeCard> {
  late List<RecipeModel> recipeList;

  @override
  void initState() {
    super.initState();
    recipeList = [...widget.recipes]; // 복사해서 상태 관리
  }

  Future<void> toggleScrap(int index) async {
    final recipe = recipeList[index];
    final repo = ref.read(recipeRepositoryProvider);

    try {
      if (recipe.scrapped) {
        await repo.cancelRecipeScrap(recipe.id);
      } else {
        await repo.recipeScrap(recipe.id);
      }

      setState(() {
        recipeList[index] = recipe.copyWith(scrapped: !recipe.scrapped);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate((recipeList.length + 1) ~/ 2, (i) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (j) {
                int index = i * 2 + j;
                if (index >= recipeList.length) {
                  return Expanded(child: Container());
                }

                final recipe = recipeList[index];

                return InkWell(
                  onTap: () {
                    context.pushNamed(
                      RecipeDetailScreen.routeName,
                      pathParameters: {'id': recipe.id.toString()},
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 175.0,
                        height: 100.0,
                        child: Stack(
                          children: [
                            // 이미지
                            Positioned.fill(
                              child: Image.network(
                                recipe.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 50),
                                  );
                                },
                              ),
                            ),
                            // 스크랩 버튼
                            Positioned(
                              bottom: 3,
                              right: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () => toggleScrap(index),
                                  icon: Icon(
                                    recipe.scrapped ? Icons.bookmark : Icons.bookmark_border,
                                    color: recipe.scrapped ? Colors.orange : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 7.0),
                            Text(
                              recipe.name,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${recipe.difficulty}, ${recipe.portion}, ${recipe.method}',
                                  style: const TextStyle(fontSize: 10.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 20.0),
          ],
        );
      }),
    );
  }
}

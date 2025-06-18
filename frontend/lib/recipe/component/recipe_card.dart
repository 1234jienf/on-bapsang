import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:frontend/recipe/model/recipe_model.dart';


class RecipeCard extends StatefulWidget {
  final List<RecipeModel> recipes;

  const RecipeCard({
    super.key,
    required this.recipes
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  @override
  Widget build(BuildContext context) {
    return _renderComponent();
  }

  Column _renderComponent() {
    return Column(
      children: List.generate(widget.recipes.length ~/ 2, (i) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(2, (j) {
                int index = i * 2 + j;
                if (index >= widget.recipes.length) {
                  return Expanded(child: Container()); // 혹은 SizedBox.shrink()
                }

                final recipe = widget.recipes[index];

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
                      Container(
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
                                decoration: BoxDecoration(
                                  // color: Colors.black45, // 반투명 배경
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 30,
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(),
                                  onPressed: () {
                                  },
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
                            const SizedBox(height: 7.0,),
                            Text(
                              recipe.name,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: [
                                Text('${recipe.difficulty}, ${recipe.portion}, ${recipe.method}',
                                style: TextStyle(fontSize: 10.0)),
                              ],
                            ),
                            // recipe.scrapped로 스크랩 유무?
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
            ),
            const SizedBox(height: 20.0),
          ],
        );
      }),
    );
  }
}

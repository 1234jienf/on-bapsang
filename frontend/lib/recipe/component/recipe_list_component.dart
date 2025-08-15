import 'package:flutter/material.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/repository/recipe_repository.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecipeListComponent extends ConsumerStatefulWidget {
  final RecipeModel recipeInfo;

  const RecipeListComponent({super.key, required this.recipeInfo});

  @override
  ConsumerState<RecipeListComponent> createState() => _RecipeListComponentState();
}

class _RecipeListComponentState extends ConsumerState<RecipeListComponent> {
  bool isScrapped = false;

  @override
  void initState() {
    super.initState();
    isScrapped = widget.recipeInfo.scrapped;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.pushNamed(
          RecipeDetailScreen.routeName,
          pathParameters: {'id': widget.recipeInfo.id.toString()},
        );
      },
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 95,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Image.network(
                    widget.recipeInfo.imageUrl,
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
              ),
            ),
            SizedBox(width: 15),

            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipeInfo.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 7.0,),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 18),
                      SizedBox(width: 3),
                      SizedBox(
                        width: 65,
                        child: Text(
                          widget.recipeInfo.time != 'nan' ? widget.recipeInfo.time : '-',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      SizedBox(width: 7),
                      Image.asset(
                        'asset/img/chef_icon.png',
                        width: 18,
                        height: 18,
                        fit: BoxFit.contain
                      ),
                      SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          widget.recipeInfo.difficulty,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: isScrapped
                    ? Icon(Icons.bookmark)
                    : Icon(Icons.bookmark_border),
                onPressed: () async {
                  try {
                    final repo = ref.read(recipeRepositoryProvider);
                    if (isScrapped) {
                      await repo.cancelRecipeScrap(widget.recipeInfo.id);
                    } else {
                      await repo.recipeScrap(widget.recipeInfo.id);
                    }

                    setState(() {
                      isScrapped = !isScrapped;
                    });
                  } catch (e) {
                    print('스크랩 실패 $e');
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
}

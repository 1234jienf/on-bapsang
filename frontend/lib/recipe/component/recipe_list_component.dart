import 'package:flutter/material.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:go_router/go_router.dart';

class RecipeListComponent extends StatefulWidget {
  final RecipeModel recipeInfo;

  const RecipeListComponent({super.key, required this.recipeInfo});

  @override
  State<RecipeListComponent> createState() => _RecipeListComponentState();
}

class _RecipeListComponentState extends State<RecipeListComponent> {
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
        padding: EdgeInsetsGeometry.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 85,
                decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(10))),
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
                )
              )
            ),
            SizedBox(width: 15),

            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipeInfo.name,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(widget.recipeInfo.portion),
                      SizedBox(width: 7),
                      Text(widget.recipeInfo.time),
                      SizedBox(width: 7),
                      Text(widget.recipeInfo.difficulty)
                    ],
                  ),
                  Text('⭐️ 4.5')  // 점수가 없음. 뭘 보여줘야할지 정해야할듯...
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: (){},
                icon: Icon(Icons.bookmark_border)
              )
            )
          ],
        ),
      ),
    );
  }
}

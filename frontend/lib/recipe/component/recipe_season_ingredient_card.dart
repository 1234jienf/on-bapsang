import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/recipe/model/recipe_season_ingredient_model.dart';
import 'package:frontend/recipe/view/recipe_season_detail_screen.dart';

class RecipeSeasonIngredientCard extends StatefulWidget {
  final RecipeSeasonIngredientModel seasonIngredientInfo;

  const RecipeSeasonIngredientCard({super.key, required this.seasonIngredientInfo});

  @override
  State<RecipeSeasonIngredientCard> createState() => _RecipeSeasonIngredientCardState();
}

class _RecipeSeasonIngredientCardState extends State<RecipeSeasonIngredientCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 제철레시피 상세로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipeSeasonDetailScreen(seasonIngredientInfo: widget.seasonIngredientInfo))
        );
      },
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image.network(
                widget.seasonIngredientInfo.imgUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
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

          SizedBox(height: 15.0),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "recipe.season_card_title".tr(namedArgs: {"ingredient": widget.seasonIngredientInfo.prdlstNmTranslated}),
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

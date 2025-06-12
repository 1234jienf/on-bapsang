import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/component/recipe_list_component.dart';
import 'package:frontend/recipe/model/recipe_detail_model.dart';


class RecipeCategoryListScreen extends StatefulWidget {
  final String categoryName;
  static String get routeName => 'RecipeCategoryListScreen';
  const RecipeCategoryListScreen({super.key, required this.categoryName});

  @override
  State<RecipeCategoryListScreen> createState() => _RecipeCategoryListScreenState();
}

class _RecipeCategoryListScreenState extends State<RecipeCategoryListScreen> {
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

  void listener() {}

  @override
  Widget build(BuildContext context) {
    final RecipeDetailModel tempRecipe = RecipeDetailModel.fromJson({
      "recipe_id": '7017133',
      "name": "소고기샤브샤브",
      "ingredients": [
        "물만두",
        "샤브샤브 소스",
        "샤브샤브 육수",
        "소고기 샤브용",
        "쌈배추",
        "알배기 배추",
        "청경채",
        "칼국수",
        "팽이버섯"
      ],
      "descriptions": "소고기 샤브샤브 끓이는법",
      "review": "뜨끈한 국물 생각날때 만들어드세요!",
      "time": "30분이내",
      "difficulty": "초급",
      "portion": "3인분",
      "method": "끓이기",
      "material_type": "소고기",
      "image_url": "https://recipe1.ezmember.co.kr/cache/recipe/2024/01/05/77850297f1ec36c826a319d102d40e121.jpg"
    });

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.categoryName
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 20.0,),
                RecipeListComponent(recipeInfo: tempRecipe)
              ]),
            )
          )
        ]
      ),
    );
  }
}

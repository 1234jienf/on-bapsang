import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import 'package:frontend/recipe/model/recipe_season_ingredient_model.dart';

class RecipeSeasonDetailScreen extends StatefulWidget {
  final RecipeSeasonIngredientModel seasonIngredientInfo;

  const RecipeSeasonDetailScreen({super.key, required this.seasonIngredientInfo});

  @override
  State<RecipeSeasonDetailScreen> createState() => _RecipeSeasonDetailScreenState();
}

class _RecipeSeasonDetailScreenState extends State<RecipeSeasonDetailScreen> {
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
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '제철 레시피',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250,
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
          SliverPadding(
            padding:EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 20.0,),
                Text(
                  '제철 ${widget.seasonIngredientInfo.prdlstNm} 레시피',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                SizedBox(height: 5.0,),
                Text(
                  '${widget.seasonIngredientInfo.mdistctns}',
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 20.0,),
                Text(
                  '효능',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                SizedBox(height: 5.0,),
                Text(
                  widget.seasonIngredientInfo.effect
                      .split('-')
                      .where((e) => e.trim().isNotEmpty)
                      .map((e) => '• ${e.trim()}')
                      .join('\n'),
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 20.0,),
                Text(
                  '구매 팁',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                SizedBox(height: 5.0,),
                Text(
                  widget.seasonIngredientInfo.purchaseMth,
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 20.0,),
                Text(
                  '조리 팁',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                SizedBox(height: 5.0,),
                Text(
                  widget.seasonIngredientInfo.cookMth,
                  style: TextStyle(fontSize: 15),
                ),

                SizedBox(height: 20.0,),
                Text(
                  '${widget.seasonIngredientInfo.prdlstNm} 레시피',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                ),
                // 여기에 제철 레시피

              ])
            )
          )
        ]
      )
    );
  }
}


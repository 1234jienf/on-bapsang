import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/component/recipe_season_ingredient_card.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/provider/recipe_season_provider.dart';

class RecipeSeasonListScreen extends ConsumerStatefulWidget {
  static String get routeName => 'RecipeSeasonListScreen';

  const RecipeSeasonListScreen({super.key});

  @override
  ConsumerState<RecipeSeasonListScreen> createState() => _RecipeSeasonListScreenState();
}

class _RecipeSeasonListScreenState extends ConsumerState<RecipeSeasonListScreen> {
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
    final seasonIngredientsAsync = ref.watch(seasonIngredientProvider);

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '제철 레시피',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      child: seasonIngredientsAsync.when(
        loading: () => SizedBox(
          height: 50.0,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => SizedBox(
          height: 50.0,
          child: Center(child: Text('$err')),
        ),
        data: (seasonIngredients) => CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Column(
                      children: [
                        SizedBox(height: 15.0),
                        RecipeSeasonIngredientCard(
                          seasonIngredientInfo: seasonIngredients[index],
                        ),
                      ],
                    );
                  },
                  childCount: seasonIngredients.length,
                ),
              )
            )
          ],
        ),
      )
    );
  }
}

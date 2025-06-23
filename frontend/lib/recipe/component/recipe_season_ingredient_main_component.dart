import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/component/recipe_card.dart';
import 'package:frontend/recipe/model/recipe_model.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:frontend/recipe/provider/recipe_season_provider.dart';

class RecipeSeasonIngredientMainComponent extends ConsumerStatefulWidget {
  const RecipeSeasonIngredientMainComponent({super.key});

  @override
  ConsumerState<RecipeSeasonIngredientMainComponent> createState() =>
      _RecipeSeasonIngredientMainComponentState();
}

class _RecipeSeasonIngredientMainComponentState
    extends ConsumerState<RecipeSeasonIngredientMainComponent> {
  String? selectedIngredient;

  @override
  Widget build(BuildContext context) {
    final seasonIngredientsAsync = ref.watch(seasonIngredientProvider);

    return seasonIngredientsAsync.when(
      loading: () => const SizedBox(
        height: 50.0,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => SizedBox(
        height: 50.0,
        child: Center(child: Text('$err')),
      ),
      data: (seasonIngredients) {
        if (seasonIngredients.isEmpty) {
          return const Text("제철 재료가 없습니다.");
        }

        // 선택이 없으면 첫 번째 재료를 기본 선택
        selectedIngredient ??= seasonIngredients[0].prdlstNm;

        final recipeListAsync = ref.watch(
          topRecipesByIngredientProvider(selectedIngredient!),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                itemCount: seasonIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = seasonIngredients[index].prdlstNm;
                  final isSelected = selectedIngredient == ingredient;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: ChoiceChip(
                      label: Text(ingredient),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          selectedIngredient = ingredient;
                        });
                      },
                      selectedColor: Colors.black,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 13,
                      ),
                      backgroundColor: Colors.white,
                      labelPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 레시피 리스트
            recipeListAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('레시피 로딩 에러: $err')),
              data: (List<RecipeModel> recipes) {
                if (recipes.isEmpty) {
                  return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 50.0,),
                          Text(
                            '${selectedIngredient} 레시피는 지금 준비중이에요.',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text('다른 제철 재료 레시피 먼저 만나보세요!'),
                          SizedBox(height: 50.0,),
                        ],
                      )
                  );
                }
                final top6 = recipes.take(6).toList();

                return RecipeCard(recipes: top6);
              },
            ),
          ],
        );
      },
    );
  }
}

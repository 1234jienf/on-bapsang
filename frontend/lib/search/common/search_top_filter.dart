import 'package:flutter/material.dart';

import '../search_recipe/component/search_show_modal_bottom_sheet.dart';

class SearchTopFilter extends StatelessWidget {
  final Widget recipeTypeIcon;
  final Widget recipeTypeOptions;
  final Widget recipeRecipeIcon;
  final Widget recipeRecipeOptions;
  final Widget recipeIngredientsIcon;
  final Widget recipeIngredientsOptions;

  const SearchTopFilter({
    super.key,
    required this.recipeTypeIcon,
    required this.recipeTypeOptions,
    required this.recipeIngredientsIcon,
    required this.recipeIngredientsOptions,
    required this.recipeRecipeIcon,
    required this.recipeRecipeOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchShowModalBottomSheet(
          recipeIcon: recipeTypeIcon,
          options: recipeTypeOptions,
        ),
        const SizedBox(width: 8.0),
        SearchShowModalBottomSheet(
          recipeIcon: recipeRecipeIcon,
          options: recipeRecipeOptions,
        ),
        const SizedBox(width: 8.0),
        SearchShowModalBottomSheet(
          recipeIcon: recipeIngredientsIcon,
          options: recipeIngredientsOptions,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/search/common/search_bottom_filter.dart';
import 'package:frontend/search/common/search_recipe_filter_header.dart';
import 'package:frontend/search/common/search_top_filter.dart';

import '../search_recipe/component/search_recipe_icon.dart';
import '../search_recipe/component/search_recipe_options.dart';

class SearchRecipeFilter extends StatelessWidget {
  final Widget? typeOptions;
  final Widget? recipeOptions;
  final Widget? ingredientOptions;
  final String? typeTitle;
  final String? recipeTitle;
  final String? ingredientTitle;
  final bool isTopFilter;

  const SearchRecipeFilter({
    super.key,
    this.typeOptions,
    this.ingredientOptions,
    this.recipeOptions,
    this.typeTitle,
    this.recipeTitle,
    this.ingredientTitle,
    required this.isTopFilter
  });

  @override
  Widget build(BuildContext context) {
    if(isTopFilter) {
      return SliverPersistentHeader(
        pinned: true,
        delegate: SearchRecipeFilterHeader(
          topFilter: SearchTopFilter(
            recipeTypeIcon: SearchRecipeIcon(title: typeTitle!),
            recipeTypeOptions: SearchRecipeOptions(
              title: typeTitle!,
              options: typeOptions!,
            ),
            recipeRecipeIcon: SearchRecipeIcon(title: recipeTitle!),
            recipeRecipeOptions: SearchRecipeOptions(
              title: recipeTitle!,
              options: recipeOptions!,
            ),
            recipeIngredientsIcon: SearchRecipeIcon(title: ingredientTitle!),
            recipeIngredientsOptions: SearchRecipeOptions(
              title: ingredientTitle!,
              options: ingredientOptions!,
            ),
          ),
          bottomFilter: SearchBottomFilter(),
        ),
      );
    } else {
      return SliverPersistentHeader(
        pinned: true,
        delegate: SearchRecipeFilterHeader(
          bottomFilter: SearchBottomFilter(),
        ),
      );
    }

  }
}

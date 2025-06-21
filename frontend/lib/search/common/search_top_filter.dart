import 'package:flutter/material.dart';

import '../search_recipe/component/search_show_modal_bottom_sheet.dart';

class SearchTopFilter extends StatelessWidget {
  final Widget recipeTypeIcon;
  final Widget recipeTypeOptions;


  const SearchTopFilter({
    super.key,
    required this.recipeTypeIcon,
    required this.recipeTypeOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchShowModalBottomSheet(
          recipeIcon: recipeTypeIcon,
          options: recipeTypeOptions,
        ),
      ],
    );
  }
}

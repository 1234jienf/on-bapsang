import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_recipe/component/search_recipe_card.dart';

class SearchRecipeScreen extends StatelessWidget {
  const SearchRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SearchRecipeCard(),
              ),
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }

  // SliverPersistentHeader _searchRecipeFilter(BuildContext context) {
  //   return SliverPersistentHeader(
  //     pinned: true,
  //     delegate: SearchRecipeFilterHeader(
  //       topFilter: SearchTopFilter(
  //         recipeTypeIcon: SearchRecipeIcon(title: '종류'),
  //         recipeTypeOptions: SearchRecipeOptions(
  //           title: '종류',
  //           options: _typeOptions(),
  //         ),
  //         recipeRecipeIcon: SearchRecipeIcon(title: '조리법'),
  //         recipeRecipeOptions: SearchRecipeOptions(
  //           title: '조리법',
  //           options: _recipeOptions(),
  //         ),
  //         recipeIngredientsIcon: SearchRecipeIcon(title: '필수 식재료'),
  //         recipeIngredientsOptions: SearchRecipeOptions(
  //           title: '필수 식재료',
  //           options: _ingredientOptions(),
  //         ),
  //       ),
  //       bottomFilter: SearchBottomFilter(),
  //     ),
  //   );
  // }
  //
  // Widget _ingredientOptions() {
  //   return Center(child: Text('식재료'));
  // }
  //
  // Widget _typeOptions() {
  //   return Center(child: Text('종류'));
  // }
  //
  // Widget _recipeOptions() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: SizedBox(
  //       height: 100,
  //       child: Wrap(
  //         direction: Axis.horizontal,
  //         alignment: WrapAlignment.start,
  //         spacing: 10.0,
  //         runSpacing: 10.0,
  //         children: List.generate(8, (index) {
  //           return ConstrainedBox(
  //             constraints: BoxConstraints(minWidth: 66, maxWidth: 80),
  //             child: Container(
  //               padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  //               decoration: BoxDecoration(
  //                 border: Border.all(width: 1.0, color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(16.0),
  //               ),
  //               child: Center(
  //                 child: Text(
  //                   '끓이기',
  //                   style: TextStyle(fontSize: 14.0),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //       ),
  //     ),
  //   );
  // }
}

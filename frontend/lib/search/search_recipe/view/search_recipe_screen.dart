import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/common/search_left_filter.dart';
import 'package:frontend/search/common/search_right_filter.dart';
import 'package:frontend/search/search_recipe/component/search_recipe_card.dart';

import '../../common/search_recipe_filter_header.dart';

class SearchRecipeScreen extends StatelessWidget {
  const SearchRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: ExcludeSemantics(
        child: CustomScrollView(
          slivers: [
            _searchRecipeFilter(),
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
      ),
    );
  }

  SliverPersistentHeader _searchRecipeFilter() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchRecipeFilterHeader(leftFilter: SearchLeftFilter(), rightFilter: SearchRightFilter()),
    );
  }
}



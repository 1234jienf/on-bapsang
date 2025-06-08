import 'package:flutter/material.dart';

import '../../../common/layout/default_layout.dart';
import '../component/search_product_card.dart';

class SearchProductScreen extends StatelessWidget {
  const SearchProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SearchProductCard(),
              ),
              childCount: 10,
            ), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 175 / 255,),
          ),
        ],
      ),
    );
  }

  // SliverPersistentHeader _searchRecipeFilter() {
  //   return SliverPersistentHeader(
  //     pinned: true,
  //     delegate: SearchRecipeFilterHeader(bottomFilter: SearchBottomFilter()),
  //   );
  // }
}

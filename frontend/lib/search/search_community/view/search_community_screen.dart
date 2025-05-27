import 'package:flutter/material.dart';
import 'package:frontend/home/component/community_card.dart';

import '../../../common/layout/default_layout.dart';
import '../../common/search_recipe_filter_header.dart';
import '../../common/search_bottom_filter.dart';

class SearchCommunityScreen extends StatelessWidget {
  const SearchCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: CustomScrollView(
        slivers: [
          _searchRecipeFilter(),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: CommunityCard(userName: 'user_0091'),
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

  SliverPersistentHeader _searchRecipeFilter() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SearchRecipeFilterHeader(bottomFilter: SearchBottomFilter()),
    );
  }

}

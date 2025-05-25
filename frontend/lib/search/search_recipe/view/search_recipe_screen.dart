import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_recipe/component/search_recipe_card.dart';

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
      delegate: _SearchRecipeFilterHeader(),
    );
  }
}

class _SearchRecipeFilterHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      height: maxExtent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('종류', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('조리법', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text('필수 식재료', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text('최신순', style: TextStyle(fontSize: 13.0)),
                    ),
                    const SizedBox(width: 14.0,),
                    GestureDetector(
                      onTap: () {},
                      child: Text('추천순', style: TextStyle(fontSize: 13.0)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get minExtent => 50.0;

  @override
  double get maxExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

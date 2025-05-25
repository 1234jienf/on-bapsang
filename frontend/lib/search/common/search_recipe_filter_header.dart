import 'package:flutter/material.dart';

class SearchRecipeFilterHeader extends SliverPersistentHeaderDelegate {
  final Widget? leftFilter;
  final Widget? rightFilter;

  SearchRecipeFilterHeader({this.leftFilter, this.rightFilter});

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
            if (leftFilter != null && rightFilter != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // left
                  leftFilter!,

                  // right
                  rightFilter!,
                ],
              ),
            if (leftFilter == null && rightFilter != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // right
                  rightFilter!,
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

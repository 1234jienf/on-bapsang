import 'package:flutter/material.dart';

class SearchRecipeFilterHeader extends SliverPersistentHeaderDelegate {
  final Widget? topFilter;
  final Widget? bottomFilter;
  final double _minExtent;
  final double _maxExtent;

  SearchRecipeFilterHeader({this.topFilter, this.bottomFilter})
    : _minExtent = (topFilter != null && bottomFilter != null) ? 70.0 : 40.0,
      _maxExtent = (topFilter != null && bottomFilter != null) ? 70.0 : 40.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      height: _maxExtent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (topFilter != null && bottomFilter != null)
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // left
                  topFilter!,

                  // right
                  bottomFilter!,
                ],
              ),
            if (topFilter == null && bottomFilter != null)
              // right
              bottomFilter!,
          ],
        ),
      ),
    );
  }

  @override
  double get minExtent => _minExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

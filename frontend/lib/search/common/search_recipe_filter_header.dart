import 'package:flutter/material.dart';

class SearchRecipeFilterHeader extends StatelessWidget {
  final Widget? topFilter;
  final Widget? bottomFilter;
  const SearchRecipeFilterHeader({super.key, this.topFilter, this.bottomFilter});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
        child: Column(
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
}

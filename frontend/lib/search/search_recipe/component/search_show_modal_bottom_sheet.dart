import 'package:flutter/material.dart';

class SearchShowModalBottomSheet extends StatelessWidget {
  final Widget recipeIcon;
  final Widget options;

  const SearchShowModalBottomSheet({
    super.key,
    required this.recipeIcon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: recipeIcon,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return options;
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class SearchRecipeFliter extends StatelessWidget {
  const SearchRecipeFliter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Center(
        child: Text(
          '종류',
          style: TextStyle(fontSize: 13.0),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

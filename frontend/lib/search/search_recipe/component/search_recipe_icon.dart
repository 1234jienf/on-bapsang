import 'package:flutter/material.dart';

class SearchRecipeIcon extends StatelessWidget {
  final String title;
  const SearchRecipeIcon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Text(title, style: TextStyle(fontSize: 12))),
    );
  }
}

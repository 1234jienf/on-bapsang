import 'package:flutter/material.dart';

import '../../../common/const/colors.dart';

class SearchRecipeIcon extends StatelessWidget {
  final String title;
  const SearchRecipeIcon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: gray400),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Row(
        children: [
          Icon(Icons.filter_list, size: 20,),
          const SizedBox(width: 10,),
          Text(title, style: TextStyle(fontSize: 12)),
        ],
      )),
    );
  }
}

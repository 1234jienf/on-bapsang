import 'package:flutter/material.dart';

class SearchRightFilter extends StatelessWidget {
  const SearchRightFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Text('최신순', style: TextStyle(fontSize: 13.0)),
        ),
        const SizedBox(width: 14.0),
        GestureDetector(
          onTap: () {},
          child: Text('추천순', style: TextStyle(fontSize: 13.0)),
        ),
      ],
    );
  }
}

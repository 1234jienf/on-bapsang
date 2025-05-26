import 'package:flutter/material.dart';

class SearchBottomFilter extends StatelessWidget {
  const SearchBottomFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
      ),
    );
  }
}

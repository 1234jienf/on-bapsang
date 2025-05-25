import 'package:flutter/material.dart';

class SearchLeftFilter extends StatelessWidget {
  const SearchLeftFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text('종류', style: TextStyle(fontSize: 12))),
        ),
        const SizedBox(width: 8.0),
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text('조리법', style: TextStyle(fontSize: 12))),
        ),
        const SizedBox(width: 8.0),
        Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text('필수 식재료', style: TextStyle(fontSize: 12))),
        ),
      ],
    );
  }
}

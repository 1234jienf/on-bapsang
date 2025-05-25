import 'package:flutter/material.dart';

class RecipeIcon extends StatelessWidget {
  const RecipeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final double fontSize = 12.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('쌀/곡류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('채소류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('가공식품류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('달걀/유제품', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('고기류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('해물류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('과일류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('건어물류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Icon(Icons.rice_bowl),
                  Text('기타', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(child: Column(children: [])),
          ],
        ),
      ],
    );
  }
}

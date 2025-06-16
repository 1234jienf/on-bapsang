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
                  Image.asset('asset/img/rice.png'),
                  Text('쌀/곡류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/vege.png'),
                  Text('채소류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/so.png'),
                  Text('가공식품류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/egg.png'),
                  Text('달걀/유제품', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/meat.png'),
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
                  Image.asset('asset/img/fish.png'),
                  Text('해물류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/fruit.png'),
                  Text('과일류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/dried.png'),
                  Text('건어물류', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Image.asset('asset/img/etc.png'),
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

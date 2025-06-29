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
              child: iconField(assetString: 'asset/img/rice.png', title: '쌀/곡류', fontSize: fontSize)
            ),
            Expanded(
              child: iconField(assetString: 'asset/img/vege.png', title: '채소류', fontSize: fontSize)
            ),
            Expanded(
              child: iconField(fontSize: fontSize, title: '가공식품류', assetString: 'asset/img/so.png')
            ),
            Expanded(
              child: iconField(assetString: 'asset/img/egg.png', title: '달걀/유제품', fontSize: fontSize)
            ),
            Expanded(
              child: iconField(assetString: 'asset/img/meat.png', title: '고기류', fontSize: fontSize)


            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: iconField(assetString: 'asset/img/fish.png', title: '해물류', fontSize: fontSize)
            ),
            Expanded(
              child: iconField(
                fontSize: fontSize,
                assetString: 'asset/img/fruit.png',
                title: '과일류',
              ),
            ),
            Expanded(
              child: iconField(
                assetString: 'asset/img/dried.png',
                title: '건어물류',
                fontSize: fontSize,
              ),
            ),
            Expanded(
              child: iconField(
                assetString: 'asset/img/etc.png',
                title: '기타',
                fontSize: fontSize,
              ),
            ),
            Expanded(child: Column(children: [])),
          ],
        ),
      ],
    );
  }

  Widget iconField({
    required String assetString,
    required String title,
    required double fontSize,
  }) {
    return Column(
      children: [
        Image.asset(assetString, fit: BoxFit.cover, width: 48, height: 48),
        Text(title, style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}

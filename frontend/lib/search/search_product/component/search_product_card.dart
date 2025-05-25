import 'package:flutter/material.dart';

class SearchProductCard extends StatelessWidget {
  const SearchProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      width: 175,
      child: Column(
        children: [
          Image.asset(
            'asset/img/product.png',
            width: 175,
            height: 175,
            fit: BoxFit.cover,
          ),
          Text(
            '풀무원 특등급 국산콩 두부 부침찌개 겸용, 300g, 2개입',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.0),
          ),
          Row(
            children: [
              Text(
                '4820원',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

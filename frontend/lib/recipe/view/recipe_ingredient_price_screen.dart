import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/recipe/component/recipe_ingredient_market_chart.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';

import 'package:frontend/recipe/component/recipe_ingredient_price_chart.dart';

class RecipeIngredientPriceScreen extends StatefulWidget {
  final String ingredientName;
  final int ingredientId;

  const RecipeIngredientPriceScreen({
    super.key,
    required this.ingredientName,
    required this.ingredientId
  });

  @override
  State<RecipeIngredientPriceScreen> createState() => _RecipeIngredientPriceScreenState();
}

class _RecipeIngredientPriceScreenState extends State<RecipeIngredientPriceScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // 임시데이터
    String jsonData1 = '''
    [
        {
            "date": "202404",
            "price": 5160
        },
        {
            "date": "202405",
            "price": 5160
        },
        {
            "date": "202406",
            "price": 5160
        },
        {
            "date": "202407",
            "price": 5160
        },
        {
            "date": "202408",
            "price": 5160
        },
        {
            "date": "202409",
            "price": 5160
        },
        {
            "date": "202410",
            "price": 5160
        },
        {
            "date": "202411",
            "price": 5160
        },
        {
            "date": "202412",
            "price": 5940
        },
        {
            "date": "202501",
            "price": 5940
        },
        {
            "date": "202502",
            "price": 5940
        },
        {
            "date": "202503",
            "price": 5940
        }
    ]
    ''';
    String jsonData2 = '''
    [
        {
            "market": "경동",
            "averagePrice": 2500
        },
        {
            "market": "남부",
            "averagePrice": 2160
        },
        {
            "market": "부전",
            "averagePrice": 2160
        },
        {
            "market": "양동",
            "averagePrice": 2160
        },
        {
            "market": "칠성",
            "averagePrice": 2500
        },
        {
            "market": "현대",
            "averagePrice": 2330
        }
    ]
    ''';

    List<dynamic> jsonList1 = json.decode(jsonData1);
    List<dynamic> jsonList2 = json.decode(jsonData2);
    final ingredientPriceDataList = jsonList1.map((item) => IngredientPriceData.fromJson(item)).toList();
    final marketDataList = jsonList2.map((item) => MarketData.fromJson(item)).toList();

    return SizedBox(
      height: screenHeight * 0.9,
      width: screenWidth,
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${widget.ingredientName}의 시세'),
              Text('디자인 추후 수정예정'),
              SizedBox(height: 20),

              // 재료 시세 차트
              RecipeIngredientPriceChart(ingredientPriceDataList: ingredientPriceDataList),

              // 지역별 재료 가격
              RecipeIngredientMarketChart(marketDataList: marketDataList)
            ],
          )
      ),
    );
  }
}
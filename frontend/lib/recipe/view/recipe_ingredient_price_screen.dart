import 'package:flutter/material.dart';
import 'package:frontend/recipe/component/recipe_ingredient_market_chart.dart';

import 'package:frontend/recipe/component/recipe_ingredient_price_chart.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/recipe/provider/recipe_price_provider.dart';

class RecipeIngredientPriceScreen extends ConsumerStatefulWidget {
  final String ingredientName;
  final int ingredientId;

  const RecipeIngredientPriceScreen({
    super.key,
    required this.ingredientName,
    required this.ingredientId
  });

  @override
  ConsumerState<RecipeIngredientPriceScreen> createState() => _RecipeIngredientPriceScreenState();
}

class _RecipeIngredientPriceScreenState extends ConsumerState<RecipeIngredientPriceScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final ingredientTimeData = ref.watch(ingredientTimeSeriesProvider(widget.ingredientId));
    final ingredientRegionData = ref.watch(ingredientRegionProvider(widget.ingredientId));

    return SizedBox(
      height: screenHeight * 0.9,
      width: screenWidth,
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.ingredientName}의 시세',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                // Text('디자인 추후 수정예정'),
                SizedBox(height: 20),

                // 재료 시세 차트
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.ingredientName}의 일자별 가격',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 15),
                ingredientTimeData.when(
                    data: (data) => RecipeIngredientPriceChart(ingredientPriceDataList: data.monthlyPrices),
                    error: (err, stack) => Center(child: Text('데이터를 가져오는 과정에서 문제가 발생하였습니다. $err')),
                    loading: () => Center(child: CircularProgressIndicator()),
                ),

                SizedBox(height: 20),

                // 지역별 재료 가격
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '시장별 ${widget.ingredientName} 도매 가격',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 15),
                ingredientRegionData.when(
                  data: (data) => RecipeIngredientMarketChart(marketDataList: data.markets),
                  error: (err, stack) => Center(child: Text('데이터를 가져오는 과정에서 문제가 발생하였습니다.$err')),
                  loading: () => Center(child: CircularProgressIndicator()),
                )
              ],
            ),
          )
      ),
    );
  }
}
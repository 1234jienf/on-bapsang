import 'package:easy_localization/easy_localization.dart';
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
    // final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final ingredientTimeData = ref.watch(ingredientTimeSeriesProvider(widget.ingredientId));
    final ingredientRegionData = ref.watch(ingredientRegionProvider(widget.ingredientId));

    return SizedBox(
      // height: screenHeight * 0.9,
      width: screenWidth,
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 40, // 충분한 높이 확보
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Text(
                          "recipe.ingredient_price_title".tr(namedArgs: {"ingredient": widget.ingredientName}),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: -5,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // 재료 시세 차트
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "recipe.ingredient_time_price".tr(namedArgs: {"ingredient": widget.ingredientName}),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                ingredientTimeData.when(
                    data: (data) => RecipeIngredientPriceChart(ingredientPriceDataList: data.monthlyPrices),
                    error: (err, stack) => SizedBox(height:280, child: Center(child: Text('${"common.error_message".tr()} $err'))),
                    loading: () => SizedBox(height:280, child: Center(child: CircularProgressIndicator())),
                ),

                SizedBox(height:5),

                // 지역별 재료 가격
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "recipe.ingredient_market_price".tr(namedArgs: {"ingredient": widget.ingredientName}),
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 10),
                ingredientRegionData.when(
                  data: (data) => RecipeIngredientMarketChart(marketDataList: data.markets),
                  error: (err, stack) => SizedBox(height:280, child: Center(child: Text('${"common.error_message".tr()} $err'))),
                  loading: () => SizedBox(height: 280, child: Center(child: CircularProgressIndicator())),
                )
              ],
            ),
          )
      ),
    );
  }
}
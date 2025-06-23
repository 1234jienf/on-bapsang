import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';

class RecipeIngredientPriceChart extends StatefulWidget {
  final List<IngredientPriceData> ingredientPriceDataList;

  const RecipeIngredientPriceChart({
    super.key,
    required this.ingredientPriceDataList
  });

  @override
  State<RecipeIngredientPriceChart> createState() => _RecipeIngredientPriceChartState();
}

class _RecipeIngredientPriceChartState extends State<RecipeIngredientPriceChart> {
  @override
  Widget build(BuildContext context) {
    if (widget.ingredientPriceDataList.isEmpty) {
      return Center(child: Text('해당 재료는 시세 데이터를 제공하지 않습니다.'));
    }

    final minIngredientPrice = widget.ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a < b ? a : b);
    final maxIngredientPrice = widget.ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a > b ? a : b);

    // 날짜 포맷 변환 함수
    String formatDate(String dateStr) {
      if (dateStr.length == 6) {
        String year = dateStr.substring(2, 4); // 24, 25
        String month = dateStr.substring(4, 6); // 04, 05, ...
        return "$year/$month";
      }
      return dateStr;
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show:false),
          backgroundColor: Colors.white,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < widget.ingredientPriceDataList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            formatDate(widget.ingredientPriceDataList[index].date),
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Text('');
                  },
                )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 500,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX:(widget.ingredientPriceDataList.length - 1).toDouble(),
          minY: minIngredientPrice - 500,
          maxY: maxIngredientPrice + 500,
          lineBarsData: [
            LineChartBarData(
              spots: widget.ingredientPriceDataList.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.price);
              }).toList(),
              isCurved: false,
              color: primaryColor,
              barWidth: 2,
              dotData: FlDotData(show: true),
            ),
          ],
        )
      )
    );
  }
}

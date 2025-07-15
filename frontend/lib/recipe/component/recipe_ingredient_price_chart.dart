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
      return SizedBox(
        height: 280,
        child: Center(child: Text('해당 재료는 시세 데이터를 제공하지 않습니다.'))
      );
    }

    final minIngredientPrice = widget.ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a < b ? a : b);
    final maxIngredientPrice = widget.ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a > b ? a : b);
    final double yInterval = ((maxIngredientPrice - minIngredientPrice) / 4).ceilToDouble();

    // 날짜 포맷 변환 함수
    String formatDate(String dateStr) {
      if (dateStr.length == 6) {
        String year = dateStr.substring(2, 4); // 년
        String month = dateStr.substring(4, 6); // 달
        return "$year/$month";
      }
      return dateStr;
    }

    return SizedBox(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipColor: (touchedSpot) => Colors.white,
              )
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => const FlLine(
                color: gray200,
                strokeWidth: 1
              ),
            ),
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
                            angle: 0,
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
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: yInterval,
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
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                right: BorderSide.none,
                bottom: BorderSide(
                  color: gray600,
                  width: 3
                ),
                left: BorderSide.none,
                top: BorderSide.none
              )
            ),
            minX: 0,
            maxX:(widget.ingredientPriceDataList.length - 1).toDouble(),
            minY: minIngredientPrice - yInterval,
            maxY: maxIngredientPrice + yInterval,
            lineBarsData: [
              LineChartBarData(
                spots: widget.ingredientPriceDataList.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value.price);
                }).toList(),
                isCurved: false,
                color: primaryColor,
                barWidth: 2,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor.withValues(alpha: 0.8),
                      primaryColor.withValues(alpha: 0)
                    ]
                  )
                )
              ),
            ],
          )
        ),
      )
    );
  }
}

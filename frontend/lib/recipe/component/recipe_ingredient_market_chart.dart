import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';

class RecipeIngredientMarketChart extends StatefulWidget {
  final List<MarketData> marketDataList;

  const RecipeIngredientMarketChart({
    super.key,
    required this.marketDataList
  });

  @override
  State<RecipeIngredientMarketChart> createState() => _RecipeIngredientMarketChartState();
}

class _RecipeIngredientMarketChartState extends State<RecipeIngredientMarketChart> {
  @override
  Widget build(BuildContext context) {

    final minMarketPrice = widget.marketDataList.map((data) => data.averagePrice).reduce((a, b) => a < b ? a : b);
    final maxMarketPrice = widget.marketDataList.map((data) => data.averagePrice).reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < widget.marketDataList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.marketDataList[index].market,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
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
                interval: 100,
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
          minY: minMarketPrice - 200,
          maxY: maxMarketPrice + 200,
          barGroups: widget.marketDataList.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.averagePrice,
                  color: Colors.blue,
                  width: 20,
                ),
              ],
            );
          }).toList(),
        )
      )
    );
  }
}

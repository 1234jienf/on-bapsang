import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/common/const/colors.dart';
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
    if (widget.marketDataList.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(child: Text('해당 재료는 시장별 데이터를 제공하지 않습니다.'))
      );
    }

    final minMarketPrice = widget.marketDataList.map((data) => data.averagePrice).reduce((a, b) => a < b ? a : b);
    final maxMarketPrice = widget.marketDataList.map((data) => data.averagePrice).reduce((a, b) => a > b ? a : b);
    final double yInterval = ((maxMarketPrice - minMarketPrice) / 4).ceilToDouble();

    return SizedBox(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: BarChart(
          BarChartData(
            // 툴팁
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
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
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < widget.marketDataList.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Transform.rotate(
                          angle: -0.4,
                          child: Text(
                            widget.marketDataList[index].market,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        )
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
            minY: minMarketPrice - yInterval,
            maxY: maxMarketPrice + yInterval,
            barGroups: widget.marketDataList.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.averagePrice,
                    color: primaryColor,
                    width: 20,
                    borderRadius: BorderRadius.zero
                  ),
                ],
              );
            }).toList(),
          )
        ),
      )
    );
  }
}

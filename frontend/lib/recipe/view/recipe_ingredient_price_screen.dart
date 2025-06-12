import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/recipe/model/recipe_price_model.dart';

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
    final minIngriendPrice = ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a < b ? a : b);
    final maxIngriendPrice = ingredientPriceDataList.map((data) => data.price).reduce((a, b) => a > b ? a : b);


    final marketDataList = jsonList2.map((item) => MarketData.fromJson(item)).toList();
    final minMarketPrice = marketDataList.map((data) => data.averagePrice).reduce((a, b) => a < b ? a : b);
    final maxMarketPrice = marketDataList.map((data) => data.averagePrice).reduce((a, b) => a > b ? a : b);

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
              SizedBox(
                  height: 300,
                  child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show:true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 50,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < ingredientPriceDataList.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Transform.rotate(
                                      angle: -0.5,
                                      child: Text(
                                        formatDate(ingredientPriceDataList[index].date),
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
                        maxX:(ingredientPriceDataList.length - 1).toDouble(),
                        minY: minIngriendPrice - 500,
                        maxY: maxIngriendPrice + 500,
                        lineBarsData: [
                          LineChartBarData(
                            spots: ingredientPriceDataList.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.price);
                            }).toList(),
                            isCurved: false,
                            color: Colors.blue,
                            barWidth: 2,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      )
                  )
              ),

              // 지역별 재료 가격
              SizedBox(
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
                                if (index >= 0 && index < marketDataList.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      marketDataList[index].market,
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
                      barGroups: marketDataList.asMap().entries.map((entry) {
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
              )
            ],
          )
      ),
    );
  }
}
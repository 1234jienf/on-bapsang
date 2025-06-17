class IngredientPriceData {
  final String date;
  final double price;

  IngredientPriceData({required this.date, required this.price});

  factory IngredientPriceData.fromJson(Map<String, dynamic> json) {
    return IngredientPriceData(
      date: json['date'],
      price: json['price'].toDouble(),
    );
  }
}

class IngredientTimeSeries {
  final String ingredient;
  final String market;
  final String unit;
  final String origin;
  final List<IngredientPriceData> monthlyPrices;

  IngredientTimeSeries({
    required this.ingredient,
    required this.market,
    required this.unit,
    required this.origin,
    required this.monthlyPrices,
  });

  factory IngredientTimeSeries.fromJson(Map<String, dynamic> json) {
    return IngredientTimeSeries(
      ingredient: json['ingredient'],
      market: json['market'],
      unit: json['unit'],
      origin: json['origin'],
      monthlyPrices: (json['monthlyPrices'] as List)
          .map((item) => IngredientPriceData.fromJson(item))
          .toList(),
    );
  }
}


class MarketData {
  final String market;
  final double averagePrice;

  MarketData({required this.market, required this.averagePrice});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      market: json['market'],
      averagePrice: json['averagePrice'].toDouble(),
    );
  }
}

class IngredientRegion {
  final int ingredientId;
  final String ingredientName;
  final String unit;
  final String yearMonth;
  final List<MarketData> markets;

  IngredientRegion({
    required this.ingredientId,
    required this.ingredientName,
    required this.unit,
    required this.yearMonth,
    required this.markets,
  });

  factory IngredientRegion.fromJson(Map<String, dynamic> json) {
    return IngredientRegion(
      ingredientId: int.parse(json['ingredientId'].toString()),
      ingredientName: json['ingredientName'],
      unit: json['unit'],
      yearMonth: json['yearMonth'],
      markets: (json['markets'] as List)
          .map((item) => MarketData.fromJson(item))
          .toList(),
    );
  }
}

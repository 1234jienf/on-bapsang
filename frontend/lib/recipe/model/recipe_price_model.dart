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
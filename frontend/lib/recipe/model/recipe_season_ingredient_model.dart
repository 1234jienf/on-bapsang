class RecipeSeasonIngredientModel {
  final int idntfcNo;
  final String prdlstNm;
  final String prdlstNmTranslated;
  final String effect;
  final String purchaseMth;
  final String cookMth;
  final String imgUrl;
  final String mdistctns;

  RecipeSeasonIngredientModel({
    required this.idntfcNo,
    required this.prdlstNm,
    required this.prdlstNmTranslated,
    required this.effect,
    required this.purchaseMth,
    required this.cookMth,
    required this.imgUrl,
    required this.mdistctns,
  });

  factory RecipeSeasonIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeSeasonIngredientModel(
      idntfcNo: json['idntfcNo'].toInt(),
      prdlstNm: json['prdlstNm'],
      prdlstNmTranslated: json['prdlstNmTranslated'],
      effect: json['effect'],
      purchaseMth: json['purchaseMth'],
      cookMth: json['cookMth'],
      imgUrl: json['imgUrl'],
      mdistctns: json['mdistctns'],
    );
  }
}
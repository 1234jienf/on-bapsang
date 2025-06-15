class SignupRequest {
  String username;
  String password;
  String? nickname;
  String? country;
  int? age;
  String? location;
  List<int> favoriteTasteIds;
  List<int> favoriteDishIds;
  List<int> favoriteIngredientIds;

  SignupRequest({
    required this.username,
    required this.password,
    this.nickname,
    this.country,
    this.age,
    this.location,
    this.favoriteTasteIds = const [],
    this.favoriteDishIds = const [],
    this.favoriteIngredientIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'nickname': nickname,
      'country': country,
      'age': age,
      'location': location,
      'favoriteTasteIds': favoriteTasteIds,
      'favoriteDishIds': favoriteDishIds,
      'favoriteIngredientIds': favoriteIngredientIds,
    };
  }
}

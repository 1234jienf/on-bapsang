import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;
  UserModelError({required this.message});
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final int id;
  final String username;
  final String nickname;
  final String country;
  final int age;
  final String location;
  final List<int> favoriteTastes;
  final List<int> favoriteDishes;
  final List<int> favoriteIngredients;

  UserModel({
    required this.id,
    required this.username,
    required this.nickname,
    required this.country,
    required this.age,
    required this.location,
    required this.favoriteTastes,
    required this.favoriteDishes,
    required this.favoriteIngredients,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] ?? json;

    return UserModel(
      id: raw['userId']  as int,
      username: raw['username'] as String,
      nickname: raw['nickname'] as String,
      country: raw['country'] as String,
      age: raw['age'] as int,
      location: raw['location'] as String,
      favoriteTastes: (raw['favoriteTastes'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
      favoriteDishes: (raw['favoriteDishes'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
      favoriteIngredients: (raw['favoriteIngredients'] as List<dynamic>? ?? []).map((e) => e as int).toList(),
    );
  }
}

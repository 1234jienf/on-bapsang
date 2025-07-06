import 'package:json_annotation/json_annotation.dart';

part 'mypage_userInfo_model.g.dart';

@JsonSerializable()
class MypageUserInfoModel {
  final int userId;
  final String username;
  final String nickname;
  final String country;
  final int age;
  final List<int> favoriteDishes;
  final List<int> favoriteTastes;
  final List<int> favoriteIngredients;

  MypageUserInfoModel({
    required this.userId,
    required this.username,
    required this.nickname,
    required this.country,
    required this.age,
    required this.favoriteDishes,
    required this.favoriteTastes,
    required this.favoriteIngredients
  });

  factory MypageUserInfoModel.fromJson(Map<String, dynamic> json)
  => _$MypageUserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$MypageUserInfoModelToJson(this);


// factory MypageUserInfoModel.fromJson(Map<String, dynamic> json) {
  //   return MypageUserInfoModel(
  //       userId: int.parse(json['userId'].toString()),
  //       username: json['username'],
  //       nickname: json['nickname'],
  //       country: json['country'],
  //       age: int.parse(json['age'].toString()),
  //       favoriteDishes: (json['favoriteDishes'] as List<dynamic> ?? [])
  //           .map((item) => item.toString())
  //           .toList(),
  //       favoriteTastes: (json['favoriteTastes'] as List<dynamic> ?? [])
  //       .map((item) => item.toString())
  //       .toList(),
  //       favoriteIngredients: (json['favoriteIngredients'] as List<dynamic>)
  //       .map((item) => item.toString())
  //       .toList(),
  //   );
  // }
}

class MypageResponseModel {
  final int status;
  final String message;
  final MypageUserInfoModel data;

  MypageResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MypageResponseModel.fromJson(Map<String, dynamic> json) {
    return MypageResponseModel(
      status: json['status'],
      message: json['message'],
      data: MypageUserInfoModel.fromJson(json['data']),
    );
  }
}
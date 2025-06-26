import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_model.g.dart';

@JsonSerializable()
class CommunityModel implements IModelWithIntId {
  @override
  final int id;
  final String imageUrl;
  final String title;
  final String nickname;
  final String content;
  final String profileImage;
  final bool scrapped;


  CommunityModel({
    required this.title,
    // ignore: non_constant_identifier_names
    required this.id,
    required this.imageUrl,
    required this.nickname,
    required this.content,
    required this.profileImage,
    required this.scrapped,
  });

  CommunityModel copyWith({
    int? id,
    String? title,
    String? imageUrl,
    String? nickname,
    String? content,
    String? profileImage,
    bool? scrapped,
  }) {
    return CommunityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      nickname: nickname ?? this.nickname,
      content: content ?? this.content,
      profileImage: profileImage ?? this.profileImage,
      scrapped: scrapped ?? this.scrapped,
    );
  }

  factory CommunityModel.fromJson(Map<String, dynamic> json) => _$CommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityModelToJson(this);

}

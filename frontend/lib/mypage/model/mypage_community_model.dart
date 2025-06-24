import 'package:frontend/common/model/int/model_with_id.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mypage_community_model.g.dart';

@JsonSerializable()
class MypageCommunityModel implements IModelWithIntId {
  @override
  @JsonKey(name: 'postId')
  final int id;
  final String imageUrl;
  final String title;
  final String nickname;
  final String content;
  final String profileImage;

  MypageCommunityModel({
    required this.title,
    required this.id,
    required this.imageUrl,
    required this.nickname,
    required this.content,
    required this.profileImage,
  });

  factory MypageCommunityModel.fromJson(Map<String, dynamic> json) => _$MypageCommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$MypageCommunityModelToJson(this);

  CommunityModel toCommunityModel() {
    return CommunityModel(
      id: id,
      title: title,
      imageUrl: imageUrl,
      nickname: nickname,
      content: content,
      profileImage: profileImage,
    );
  }
}

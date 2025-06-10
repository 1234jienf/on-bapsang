import 'package:frontend/common/utils/data_uitls.dart';
import 'package:json_annotation/json_annotation.dart';

part 'community_comment_model.g.dart';

@JsonSerializable()
class CommunityCommentModel {
  final int id;
  final String content;
  final String nickname;
  final String? profileImage;
  @JsonKey(fromJson: DataUtils.dateTimeFromJson)
  final DateTime createdAt;
  final List<dynamic> children;

  CommunityCommentModel({
    required this.id,
    required this.content,
    required this.profileImage,
    required this.createdAt,
    required this.nickname,
    required this.children,
  });

  factory CommunityCommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommunityCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommunityCommentModelToJson(this);
}

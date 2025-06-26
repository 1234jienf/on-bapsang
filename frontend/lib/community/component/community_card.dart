import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/community/provider/community_provider.dart';
import 'package:frontend/community/provider/community_scrap_provider.dart';

import '../model/community_model.dart';

class CommunityCard extends ConsumerWidget {
  final String nickname;
  final String title;
  final String imageUrl;
  final int id;
  final String content;
  final String profileImage;
  final bool scrapped;

  const CommunityCard({
    super.key,
    required this.nickname,
    required this.title,
    required this.imageUrl,
    required this.id,
    required this.content,
    required this.profileImage,
    required this.scrapped,
  });

  factory CommunityCard.fromModel({required CommunityModel model}) {
    return CommunityCard(
      title: model.title,
      id: model.id,
      imageUrl: model.imageUrl,
      nickname: model.nickname,
      content: model.content,
      profileImage: model.profileImage,
      scrapped: model.scrapped,
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SizedBox(
      width: 175,
      height: 260,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: 175,
              height: 175,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 2.0,
                    ),
                    child: Row(
                      children: [
                        profileImage.isEmpty
                            ? Icon(Icons.account_circle_outlined, size: 20)
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                                width: 20,
                                height: 20,
                              ),
                            ),
                        const SizedBox(width: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              nickname,
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      ref.read(communityScrapProvider).scrap(id: id.toString());
                      ref.read(communityProvider.notifier).updateScrapStatus(id, !scrapped);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            scrapped ?
                            "community.fail_scrap".tr() : "community.success_scrap".tr(),
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: primaryColor,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Icon(
                      scrapped
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      size: 20,
                      color: scrapped ? primaryColor : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            content,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../model/community_model.dart';

class CommunityCard extends StatelessWidget {
  final String nickname;
  final String title;
  final String imageUrl;
  final int id;

  const CommunityCard({
    super.key,
    required this.nickname,
    required this.title,
    required this.imageUrl,
    required this.id,
  });

  factory CommunityCard.fromModel({required CommunityModel model}) {
    return CommunityCard(
      title: model.title,
      id: model.id,
      imageUrl: model.imageUrl,
      nickname: model.nickname,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _renderComponent();
  }

  Widget _renderComponent() {
    return SizedBox(
      width: 175,
      height: 260,
      child: Column(
        children: [
          Hero(tag: ObjectKey(id.toString()),
              child: ClipRRect(borderRadius: BorderRadius.circular(12.0),
                child: Image.network(imageUrl, fit: BoxFit.cover, width: 175, height: 175,),)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.account_circle_outlined, size: 20),
                        const SizedBox(width: 5.0),
                        Text(
                          nickname,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.favorite_border_outlined, size: 20),
                ],
              ),
              const SizedBox(height: 6.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
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
            ],
          ),
        ],
      ),
    );
  }
}

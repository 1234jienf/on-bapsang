import 'package:flutter/material.dart';

import '../../common/const/colors.dart';
import '../model/community_tag_position_model.dart';

class CommunityBuildTag extends StatelessWidget {
  final CommunityTagPositionModel tag;
  final bool isVisible;

  const CommunityBuildTag({
    super.key,
    required this.tag,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tagWidth = 210.0;

    double adjustedX = tag.x - 12;

    // 왼쪽으로 넘어가는 경우
    if (adjustedX < 0) {
      adjustedX = 10;
    }

    // 오른쪽으로 넘어가는 경우
    if (adjustedX + tagWidth > screenWidth) {
      adjustedX = screenWidth - tagWidth - 10;
    }

    return Positioned(
      left: isVisible ? adjustedX : screenWidth - 70,
      top: isVisible ? tag.y - 50 : 365,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: isVisible
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
              height: 65,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    Image.network(
                      tag.imageUrl,
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        tag.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 2,
              height: 20,
              color: Colors.grey,
              margin: EdgeInsets.only(left: (tag.x - adjustedX - 12)),
            ),
            Container(
              width: 12,
              height: 12,
              margin: EdgeInsets.only(left: (tag.x - adjustedX - 12)),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        )
            : Container(
          width: 60,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: gray800,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'asset/img/Vector.png',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 6),
              Text(
                '1',
                style: TextStyle(
                  color: gray000,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
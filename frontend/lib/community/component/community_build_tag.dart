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

    // 텍스트 길이에 따른 동적 태그 너비 계산
    final textPainter = TextPainter(
      text: TextSpan(
        text: tag.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 180); // 최대 텍스트 너비 제한

    // 이미지(40) + 간격(10) + 텍스트 + 패딩(20) + 여유공간(20)
    double tagWidth = 40 + 10 + textPainter.width + 20 + 20;

    // 최소/최대 너비 제한
    if (tagWidth < 100) tagWidth = 100;
    if (tagWidth > 250) tagWidth = 250;


    double tagBoxLeft = tag.x - (tagWidth / 2);

    if (isVisible) {
      if (tagBoxLeft < 10) {
        tagBoxLeft = 10;
      }

      if (tagBoxLeft + tagWidth > screenWidth - 10) {
        tagBoxLeft = screenWidth - tagWidth - 10;
      }
    }


    double lineAndCircleOffset = tag.x - tagBoxLeft - 6;


    if (lineAndCircleOffset < 6) {
      lineAndCircleOffset = 6;
    }


    if (lineAndCircleOffset > tagWidth - 18) {
      lineAndCircleOffset = tagWidth - 18;
    }


    return Positioned(
      left: isVisible ? tagBoxLeft : screenWidth - 70,
      top: isVisible ? tag.y - 95 : 365,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: isVisible
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
              height: 57,
              width: tagWidth,
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
                    const SizedBox(width: 16),
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
              color: Colors.white,
              margin: EdgeInsets.only(left: lineAndCircleOffset),
            ),
            Container(
              width: 12,
              height: 12,
              margin: EdgeInsets.only(left: lineAndCircleOffset - 5),
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
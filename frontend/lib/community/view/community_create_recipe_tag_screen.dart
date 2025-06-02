import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

import '../component/community_app_bar.dart';

class TagPosition {
  final double x;
  final double y;
  final String name;

  TagPosition({required this.x, required this.y, required this.name});
}

class CommunityCreateRecipeTagScreen extends StatefulWidget {
  static String get routeName => 'CommunityCreateRecipeTagScreen';

  const CommunityCreateRecipeTagScreen({super.key});

  @override
  State<CommunityCreateRecipeTagScreen> createState() =>
      _CommunityCreateRecipeTagScreenState();
}

class _CommunityCreateRecipeTagScreenState
    extends State<CommunityCreateRecipeTagScreen> {
  final ScrollController controller = ScrollController();
  List<TagPosition> tags = [];
  bool isTag = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CommunityAppBar(
        index: 1,
        next: '다음',
        title: '레시피 태그',
        isFirst: false,
      ),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              _imageWithTags(),
              if (isTag)
                ...tags
                    .map(
                      (tag) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'asset/img/community_detail_pic.png',
                              fit: BoxFit.cover,
                              width: 85,
                              height: 85,
                            ),
                            SizedBox(
                              width: 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '간단하게 만드는 밥도둑, 팽이버섯 두부 조림',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "설명 칸입니다",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  tags.remove(tag);
                                  isTag = false;
                                });
                              },
                              child: Icon(Icons.close_outlined, size: 25),
                            ),
                          ],
                        ),
                      ),
                    )
              else
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(
                    "원하는 위치에 레세피를 태그하세요",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imageWithTags() {
    return GestureDetector(
      onTapDown: (details) {
        if (isTag) {
          showDialog(
            context: context,
            builder: (context) => _isTagshowTagDialog(),
          );
        } else {
          final localPosition = details.localPosition;
          _showTagDialog(localPosition);
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'asset/img/community_detail_pic.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            ...tags.map((tag) => _buildTag(tag)),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(TagPosition tag) {
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
      left: adjustedX,
      top: tag.y - 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 텍스트 박스
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
                  Image.asset(
                    'asset/img/community_detail_pic.png',
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

          // 연결선
          Container(
            width: 2,
            height: 20,
            color: Colors.grey,
            margin: EdgeInsets.only(left: (tag.x - adjustedX - 12)),
          ),

          // 버튼
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
      ),
    );
  }

  void _showTagDialog(Offset position) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 3 / 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '레시피 태그 추가',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: '검색',
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        tags.add(
                          TagPosition(
                            x: position.dx,
                            y: position.dy,
                            name: value,
                          ),
                        );
                        isTag = true;
                      });
                      context.pop();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  AlertDialog _isTagshowTagDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.priority_high_outlined, size: 50),
              Column(
                children: [
                  Text(
                    '레시피 태그는 한 개만 등록 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: BoxBorder.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 4,
                        ),
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

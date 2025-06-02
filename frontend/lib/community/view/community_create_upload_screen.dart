import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_app_bar.dart';

class CommunityCreateUploadScreen extends StatelessWidget {
  static String get routeName => 'CommunityCreateUploadScreen';

  const CommunityCreateUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: CommunityAppBar(
        index: 2,
        title: '커뮤니티 올리기',
        next: '업로드',
        isFirst: false,
        isLast: true,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/community_detail_pic.png',
              fit: BoxFit.cover,
              width: 370,
              height: 370,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '제목은 최대 20자 가능합니다.',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                contentPadding: EdgeInsets.only(
                  left: 5.0,
                  top: 26.0,
                  bottom: 10.0,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: '요리에 대한 소개를 해보세요.',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 5.0, top: 10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

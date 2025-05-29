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
      ),
      child: Center(child: Text('upload')),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../component/community_app_bar.dart';

class CommunityCreateRecipeTagScreen extends StatelessWidget {
  static String get routeName => 'CommunityCreateRecipeTagScreen';
  final ScrollController controller = ScrollController();

  CommunityCreateRecipeTagScreen({super.key});

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
              Image.asset(
                'asset/img/community_detail_pic.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _addRecipeTag(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _addRecipeTag(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return Container(color: Colors.black, height: 100,);
          },
        );
      },
      child: Container(
        height: 55,
        width: 360,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text('레시피 태그 추가', style: TextStyle(fontSize: 14.0)),
        ),
      ),
    );
  }
}

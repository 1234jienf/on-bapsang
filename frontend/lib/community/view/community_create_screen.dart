import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class CommunityCreateScreen extends StatelessWidget {
  static String get routeName => 'CommunityCreateScreen';

  const CommunityCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Icon(Icons.close_outlined),
        ),
        elevation: 0,
        title: Text(
          "사진 업로드",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                "다음",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          _content(context),
          const SizedBox(height: 8.0),
          Expanded(child: _imageSelectList()),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      color: Colors.grey,
    );
  }

  Widget _imageSelectList() {
    return GridView.builder(
      itemCount: 100,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 3,
        crossAxisSpacing: 3,
        childAspectRatio: 1,
      ),
      itemBuilder: (_, index) => Container(color: Colors.red),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/home/component/category_icons.dart';
import 'package:frontend/recipe/view/recipe_root_screen.dart';
import 'package:go_router/go_router.dart';

class HomeMenuScreen extends StatefulWidget {
  const HomeMenuScreen({super.key});
  static String get routeName => 'HomeMenuScreen';

  @override
  State<HomeMenuScreen> createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends State<HomeMenuScreen> {
  @override
  Widget build(BuildContext context) {
    // 컴포넌트 사이 갭
    final double componentGap = 25.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 20.0;

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('전체 메뉴'),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sideGap),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: componentGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '레시피',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed(RecipeRootScreen.routeName);
                    },
                    child: Icon(Icons.chevron_right, size: 30),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              CategoryIcons(type: 'recipe'),
              SizedBox(height: componentGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '쇼핑',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed('shopping');
                    },
                    child: Icon(Icons.chevron_right, size: 30),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              CategoryIcons(type: 'shopping'),
              SizedBox(height: componentGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '커뮤니티',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed('community');
                    },
                    child: Icon(Icons.chevron_right, size: 30),
                  )
                ],
              ),
              SizedBox(height: componentGap),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '주변',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.goNamed('maps');
                    },
                    child: Icon(Icons.chevron_right, size: 30),
                  )
                ],
              ),
              SizedBox(height: componentGap),
            ],
          ),
        ),
      ),
    );
  }
}

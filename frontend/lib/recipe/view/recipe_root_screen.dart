import 'package:flutter/material.dart';
import 'package:frontend/recipe/component/recipe_appbar.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/recipe/component/recipe_card.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';

class RecipeRootScreen extends StatefulWidget {
  static String get routeName => 'RecipeRootScreen';

  const RecipeRootScreen({super.key});

  @override
  State<RecipeRootScreen> createState() => _RecipeRootScreenState();
}

class _RecipeRootScreenState extends State<RecipeRootScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    // 사진, 텍스트 사이 갭
    final double titleTextGap = 10.0;
    // 컴포넌트 사이 갭
    final double componentGap = 20.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 5.0;

    return DefaultLayout(
        appBar: RecipeAppbar(isImply: false),
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: componentGap),
                  // 제철 레시피 이미지 들어가야함
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        RecipeSeasonListScreen.routeName
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sideGap),
                      child: Container(
                        width: 360,
                        height: 90,
                        decoration: BoxDecoration(color: Colors.grey),
                        child: Text('제철레시피(이미지 들어갈 예정)'),
                      ),
                    ),
                  ),
                  SizedBox(height: componentGap),

                  // 인기 레시피
                  titleWidget(
                    title: '인기 레시피',
                    fontSize: 16,
                    sidePadding: sideGap,
                  ),
                  SizedBox(height: titleTextGap),
                  RecipeCard(count: 6),
                  SizedBox(height: componentGap),

                  // AI 추천 레시피
                  titleWidget(
                    title: 'AI 추천 레시피',
                    fontSize: 16,
                    sidePadding: sideGap,
                  ),
                  SizedBox(height: titleTextGap),
                  RecipeCard(count: 6),
                  SizedBox(height: componentGap),

                  // 컨텐츠 추가 예정
                ]),
              ),
            ),
          ],
        )
    );
  }
}

Widget titleWidget({
  required String title,
  required double fontSize,
  required double sidePadding,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
        ),
        // Text('더보기 >'),  // 더보기가 있나?
      ],
    ),
  );
}
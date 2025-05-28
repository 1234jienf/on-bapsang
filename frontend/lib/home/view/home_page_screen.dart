import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/view/search_main_screen.dart';
import 'package:go_router/go_router.dart';

import '../../common/appbar/home_appbar.dart';
import '../component/community_card.dart';
import '../component/recipe_card.dart';
import '../component/recipe_icon.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
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
      appBar: HomeAppbar(isImply: false),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    context.pushNamed(SearchMainScreen.routeName);
                  },
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: sideGap),
                      child: Container(
                        width: 360,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, size: 20.0),
                              const SizedBox(width: 5.0),
                              Text(
                                '검색',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: componentGap),

                // TODO : AI 배너
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sideGap),
                  child: Container(
                    width: 360,
                    height: 90,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                SizedBox(height: componentGap),

                // Recipe Icon
                RecipeIcon(),
                SizedBox(height: componentGap),

                // 인기 레시피
                titleWidget(
                  title: '인기 레시피',
                  fontSize: 16,
                  sidePadding: sideGap,
                ),
                SizedBox(height: titleTextGap),
                RecipeCard(count: 10),
                SizedBox(height: componentGap),

                // 제철재료 레시피
                titleWidget(
                  title: '제철재료 레시피',
                  fontSize: 16,
                  sidePadding: sideGap,
                ),
                SizedBox(height: titleTextGap),
              ]),
            ),
          ),

          _seasonalRecipe(count: 10),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: componentGap),

                // 추천 레시피
                titleWidget(
                  title: '추천 레시피',
                  fontSize: 16,
                  sidePadding: sideGap,
                ),
                SizedBox(height: titleTextGap),
                RecipeCard(count: 10),
                SizedBox(height: componentGap),

                // 커뮤니티
                titleWidget(title: '커뮤니티', fontSize: 16, sidePadding: sideGap),
                SizedBox(height: titleTextGap),
              ]),
            ),
          ),

          // SliverPadding 안에 CustomScrollView 중첩해서 쓰면 안된다.
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, index) => GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: CommunityCard(userName: 'user_0028'),
                  ),
                ),
                childCount: 6,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 175 / 255,
              ),
            ),
          ),
        ],
      ),
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
        Text('더보기 >'),
      ],
    ),
  );
}

SliverToBoxAdapter _seasonalRecipe({required int count}) {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 175, height: 100, color: Colors.grey),
                  const SizedBox(height: 7),
                  Text(
                    '메뉴명',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  Text('9900원, 30분, 초보', style: TextStyle(fontSize: 10)),
                  Text('스크랩 수 $count', style: TextStyle(fontSize: 10)),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

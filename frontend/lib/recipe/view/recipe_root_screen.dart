import 'package:flutter/material.dart';
import 'package:frontend/home/component/category_icons.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/component/recipe_appbar.dart';
import 'package:frontend/recipe/component/recipe_popular_list.dart';
import 'package:frontend/recipe/component/recipe_recommend_list.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';

class RecipeRootScreen extends ConsumerStatefulWidget {
  static String get routeName => 'RecipeRootScreen';

  const RecipeRootScreen({super.key});

  @override
  ConsumerState<RecipeRootScreen> createState() => _RecipeRootScreenState();
}

class _RecipeRootScreenState extends ConsumerState<RecipeRootScreen> {
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
        appBar: RecipeAppbar(isImply: false, searchMessage: '레시피를 검색해보세요!',),
        backgroundColor: Colors.white,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(popularRecipesProvider);
            ref.invalidate(recommendRecipesProvider);
          },
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: componentGap),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RecipeSeasonListScreen.routeName
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sideGap),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.grey),
                          child: Image.asset(
                            'asset/img/season_recipe_banner.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: componentGap),

                    CategoryIcons(type: 'recipe'),
                    SizedBox(height: componentGap),

                    // 인기 레시피
                    titleWidget(
                      title: '요즘 핫한 인기 레시피',
                      fontSize: 20,
                      sidePadding: sideGap,
                    ),
                    SizedBox(height: titleTextGap),
                    RecipePopularList(),
                    SizedBox(height: componentGap),

                    // AI 추천 레시피
                    titleWidget(
                      title: 'AI 추천 레시피',
                      fontSize: 20,
                      sidePadding: sideGap,
                    ),
                    SizedBox(height: titleTextGap),
                    RecipeRecommendList(),
                    SizedBox(height: componentGap),

                    // 컨텐츠 추가 예정
                  ]),
                ),
              ),
            ],
          ),
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
import 'package:flutter/material.dart';
import 'package:frontend/home/component/category_icons.dart';
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/component/recipe_appbar.dart';
import 'package:frontend/recipe/component/recipe_popular_list.dart';
import 'package:frontend/recipe/component/recipe_recommend_list.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';

// 언어에 따른 배너 세팅
String bannerAsset(BuildContext ctx) {
  switch (ctx.locale.languageCode) {
    case 'ko':
      return 'asset/img/season_recipe_ko.png';
    case 'ja':
      return 'asset/img/season_recipe_ja.png';
    case 'zh':
      return 'asset/img/season_recipe_zh.png';
    default:
      return 'asset/img/season_recipe_en.png';
  }
}

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

    return DefaultLayout(
        appBar: RecipeAppbar(isImply: false, searchMessage: "recipe.search_hint",),
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
                    SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(
                          RecipeSeasonListScreen.routeName
                        );
                      },
                      child: Image.asset(
                        bannerAsset(context),
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: componentGap),

                    CategoryIcons(type: 'recipe'),
                    SizedBox(height: componentGap),

                    // 인기 레시피
                    titleWidget(
                      title: "home.main_popular_recipe".tr(),
                      fontSize: 20,
                    ),
                    SizedBox(height: titleTextGap),
                    RecipePopularList(),
                    SizedBox(height: componentGap),

                    // AI 추천 레시피
                    titleWidget(
                      title: "home.main_recommend_recipe".tr(),
                      fontSize: 20,
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
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
      ),
    ],
  );
}
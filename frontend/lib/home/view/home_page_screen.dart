import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/component/single_int_grid_view.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/home/component/category_icons.dart';
import 'package:frontend/home/provider/home_screen_community_provider.dart';
import 'package:frontend/recipe/component/recipe_appbar.dart';
import 'package:frontend/recipe/component/recipe_popular_list.dart';
import 'package:frontend/recipe/component/recipe_recommend_list.dart';
import 'package:frontend/recipe/component/recipe_season_ingredient_main_component.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';
import 'package:go_router/go_router.dart';

import '../../community/component/community_card.dart';
import '../../community/view/community_detail_screen.dart';

class HomePageScreen extends ConsumerStatefulWidget {
  const HomePageScreen({super.key});

  @override
  ConsumerState<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ConsumerState<HomePageScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 사진, 텍스트 사이 갭
    final double titleTextGap = 10.0;
    // 컴포넌트 사이 갭
    final double componentGap = 20.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 5.0;

    return DefaultLayout(
      appBar: RecipeAppbar(isImply: false, searchMessage: '온밥 통합검색',),
      // appBar: HomeAppbar(isImply: false),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10.0),
                // GestureDetector(
                //   onTap: () {
                //     context.pushNamed(SearchMainScreen.routeName);
                //   },
                //   child: InkWell(
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(horizontal: sideGap),
                //       child: Container(
                //         width: 360,
                //         height: 50,
                //         decoration: BoxDecoration(
                //           color: const Color(0xFFEEEEEE),
                //         ),
                //         child: Padding(
                //           padding: const EdgeInsets.all(16.0),
                //           child: Row(
                //             children: [
                //               Icon(Icons.search, size: 20.0),
                //               const SizedBox(width: 5.0),
                //               Text(
                //                 '검색',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w500,
                //                   fontSize: 14.0,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: componentGap),

                Image.asset('asset/img/home_AI_recipe_banner.png'),

                SizedBox(height: componentGap),

                // Recipe Icon
                CategoryIcons(type: 'recipe'),

                SizedBox(height: 50.0,),

                // 인기 레시피
                titleWidget(
                  title: '요즘 핫한 인기 레시피',
                  fontSize: 20,
                  sidePadding: sideGap,
                ),
                SizedBox(height: titleTextGap),
                RecipePopularList(),
                SizedBox(height: 50.0,),

                // 제철재료 레시피
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sideGap),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '지금 꼭 먹어야 할 제철 레시피',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(
                              RecipeSeasonListScreen.routeName
                          );
                        },
                        child: Text('더보기 >')
                      )
                    ],
                  ),
                ),
                RecipeSeasonIngredientMainComponent(),
                SizedBox(height: titleTextGap),
              ]),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 50.0,),

                // 추천 레시피
                titleWidget(
                  title: '추천 레시피',
                  fontSize: 20,
                  sidePadding: sideGap,
                ),
                SizedBox(height: titleTextGap),
                RecipeRecommendList(),
                SizedBox(height: 50.0,),

                // 커뮤니티
                titleWidget(title: '커뮤니티', fontSize: 16, sidePadding: sideGap),
                SizedBox(height: titleTextGap),
              ]),
            ),
          ),

          // SliverPadding 안에 CustomScrollView 중첩해서 쓰면 안된다.
          SingleIntGridView(
            itemBuilder: <CommunityModel>(_, index, model) {
              return GestureDetector(
                onTap: () {
                  context.pushNamed(
                    CommunityDetailScreen.routeName,
                    pathParameters: {'id': model.id.toString()},
                  );
                },
                child: CommunityCard.fromModel(model: model),
              );
            },
            provider: homeScreenCommunityProvider,
            childAspectRatio: 175 / 255,
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
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w800),
        ),
        // Text('더보기 >')
      ],
    ),
  );
}


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
import 'package:frontend/recipe/provider/recipe_provider.dart';
import 'package:frontend/recipe/provider/recipe_season_provider.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';
import 'package:frontend/user/model/user_model.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../community/component/community_card.dart';
import '../../community/view/community_detail_screen.dart';
import '../../search/view/search_main_screen.dart';

// 언어에 따른 배너 세팅
String bannerAsset(BuildContext ctx) {
  switch (ctx.locale.languageCode) {
    case 'ko':
      return 'asset/img/home_AI_recipe_banner_ko.png';
    case 'ja':
      return 'asset/img/home_AI_recipe_banner_ja.png';
    case 'zh':
      return 'asset/img/home_AI_recipe_banner_zh.png';
    default:
      return 'asset/img/home_AI_recipe_banner_en.png';
  }
}

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

    ref.listen<UserModelBase?>(userProvider, (prev, next) {
      if (prev != next) {
        ref.invalidate(popularRecipesProvider);
        ref.invalidate(recommendRecipesProvider);
        ref.invalidate(seasonIngredientProvider);
        final communityNotifier = ref.refresh(homeScreenCommunityProvider.notifier);
        communityNotifier.fetchData();
      }
    });

    return DefaultLayout(
      appBar: RecipeAppbar(isImply: false, searchMessage: 'search.search_hint',),
      // appBar: HomeAppbar(isImply: false),
      backgroundColor: Colors.white,
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(popularRecipesProvider);
          ref.invalidate(recommendRecipesProvider);
          ref.invalidate(seasonIngredientProvider);
          final communityNotifier =
            ref.refresh(homeScreenCommunityProvider.notifier);
          await communityNotifier.fetchData();
        },
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 10.0),
        
                  GestureDetector(
                    onTap : () {
                      context.pushNamed(SearchMainScreen.routeName);
                    },
                    child: Image.asset(
                      bannerAsset(context),
                      fit: BoxFit.cover,
                    )
                  ),
        
                  SizedBox(height: componentGap),
        
                  // Recipe Icon
                  CategoryIcons(type: 'recipe'),
        
                  SizedBox(height: componentGap),
        
                  // 인기 레시피
                  titleWidget(
                    titleKey: 'home.main_popular_recipe',
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
                          'home.main_season_recipe'.tr(),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pushNamed(
                                RecipeSeasonListScreen.routeName
                            );
                          },
                          child: Text('${"common.more".tr()} >')
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
                    titleKey: 'home.main_recommend_recipe',
                    fontSize: 20,
                    sidePadding: sideGap,
                  ),
                  SizedBox(height: titleTextGap),
                  RecipeRecommendList(),
                  SizedBox(height: 50.0,),
        
                  // 커뮤니티
                  titleWidget(
                    titleKey: 'home.main_community',
                    fontSize: 20,
                    sidePadding: sideGap
                  ),
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
      ),
    );
  }
}

Widget titleWidget({
  required String titleKey,
  required double fontSize,
  required double sidePadding,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: sidePadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titleKey.tr(),
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w800),
        ),
        // Text('더보기 >')
      ],
    ),
  );
}


import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/view/splash_screen.dart';
import 'package:frontend/community/model/community_upload_recipe_final_list_model.dart';
import 'package:frontend/community/view/community_create_recipe_tag_screen.dart';
import 'package:frontend/community/view/community_create_screen.dart';
import 'package:frontend/community/view/community_create_upload_screen.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:frontend/community/view/community_root_screen.dart';
import 'package:frontend/home/view/home_alarm_screen.dart';
import 'package:frontend/home/view/home_menu_screen.dart';
import 'package:frontend/maps/view/maps_root_screen.dart';
import 'package:frontend/mypage/model/mypage_userInfo_model.dart';
import 'package:frontend/mypage/view/mypage_community_screen.dart';
import 'package:frontend/mypage/view/mypage_fix_info_screen.dart';
import 'package:frontend/mypage/view/mypage_root_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_community_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_recipe_screen.dart';
import 'package:frontend/recipe/view/recipe_category_list_screen.dart';
import 'package:frontend/recipe/view/recipe_root_screen.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:frontend/recipe/view/recipe_season_list_screen.dart';
import 'package:frontend/search/view/search_root_screen.dart';
import 'package:frontend/shopping/view/shopping_detail/view/shopping_payment.dart';
import 'package:frontend/shopping/view/shopping_root_screen.dart';
import 'package:frontend/signup/view/sign_up_root_screen.dart';
import 'package:frontend/user/view/login_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../community/model/community_next_upload_model.dart';
import '../../../home/view/home_page_screen.dart';
import '../../../maps/view/maps_screen.dart';
import '../../../search/view/search_main_screen.dart';
import '../../../shopping/view/shopping_cart_screen.dart';
import '../../../shopping/view/shopping_detail/view/shopping_detail_screen.dart';
import '../../../user/model/user_model.dart';
import '../../../user/provider/user_provider.dart';
import '../../view/root_tab.dart';

final mainProvider = ChangeNotifierProvider<MainProvider>((ref) {
  return MainProvider(ref: ref);
});

class MainProvider extends ChangeNotifier {
  final Ref ref;

  MainProvider({required this.ref}) {
    ref.listen<UserModelBase?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners();
      }
    });
  }

  List<RouteBase> get routes => [
    GoRoute(
      path: '/splash',
      name: 'SplashScreen',
      builder: (_, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, state) => const LoginScreen(),
      routes: [
        GoRoute(
          path: 'signup',
          name: 'SignUpRootScreen',
          builder: (_, state) => SignUpRootScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return RootTab(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          pageBuilder: (_, state) => const NoTransitionPage(child: HomePageScreen()),
          routes: [
            GoRoute(
              path: 'menu',
              name: 'HomeMenuScreen',
              builder: (_, state) => const HomeMenuScreen(),
            ),
            GoRoute(
              path: 'alarm',
              name: 'HomeAlarmScreen',
              builder: (_, state) => const HomeAlarmScreen(),
            ),
            GoRoute(
              path: 'recipe',
              name: 'RecipeRootScreen',
              pageBuilder: (_, state) => const NoTransitionPage(child: RecipeRootScreen()),
              routes: [
                GoRoute(
                  path: 'season',
                  name: 'RecipeSeasonListScreen',
                  builder: (_, state) => const RecipeSeasonListScreen(),
                ),
                GoRoute(
                  path: ':category',
                  name: 'RecipeCategoryListScreen',
                  builder:
                      (_, state) => RecipeCategoryListScreen(
                        categoryName: state.pathParameters['category']!,
                      ),
                ),
              ],
            ),
            GoRoute(
              path: 'shopping',
              name: 'shopping',
              pageBuilder: (_, state) => const NoTransitionPage(child: ShoppingRootScreen()),
            ),
            GoRoute(
              path: 'community',
              name: 'community',
              pageBuilder: (_, state) => const NoTransitionPage(child: CommunityRootScreen()),
            ),
            GoRoute(
              path: 'maps',
              name: 'maps',
              pageBuilder: (_, state) => const NoTransitionPage(child: MapsRootScreen()),
              routes: [
                GoRoute(
                  path: 'location',
                  name: 'location',
                  builder: (_, state) {
                    final locationData = state.extra as Map<String, dynamic>?;

                    return MapScreen(
                      lat: locationData?['lat'] ?? 0.0,
                      lng: locationData?['lng'] ?? 0.0,
                      isFirstLoading: false,
                    );
                  },
                ),
              ],
            ),

            GoRoute(
              path: 'mypage',
              name: 'MypageRootScreen',
              builder: (_, state) => const MypageRootScreen(),
              routes: [
                GoRoute(
                  path: 'scrap/recipe',
                  name: 'MypageScrapRecipeScreen',
                  builder: (_, state) => const MypageScrapRecipeScreen(),
                ),
                GoRoute(
                  path: 'scrap/community',
                  name: 'MypageScrapCommunityScreen',
                  builder: (_, state) => const MypageScrapCommunityScreen(),
                ),
                GoRoute(
                  path: 'community',
                  name: 'MypageCommunityScreen',
                  builder: (_, state) => const MypageCommunityScreen(),
                ),
                GoRoute(
                  path: 'fix',
                  name: 'MypageFixInfoScreen',
                  builder: (context, state) {
                    final jsonMap = state.extra as Map<String, dynamic>?;
                    final info = jsonMap == null
                        ? null
                        : MypageUserInfoModel.fromJson(jsonMap);
                    return MypageFixInfoScreen(info: info);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    GoRoute(
      path: '/search',
      name: 'SearchMainScreen',
      builder: (_, state) => const SearchMainScreen(),
      routes: [
        // GoRoute(
        //   path: 'api',
        //   name: 'SearchRecipeScreen',
        //   builder: (_, state) {
        //     final String name = state.extra as String;
        //     return SearchRecipeScreen(name: name,);
        //   },
        // ),
        GoRoute(
          path: 'result',
          name: 'SearchRootScreen',
          builder: (_, state) => const SearchRootScreen(),
        ),
      ],
    ),
    // navbar 사용 안함
    GoRoute(
      path: '/recipe/detail/:id',
      name: 'RecipeDetailScreen',
      builder:
          (_, state) => RecipeDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/shopping/detail',
      name: 'ShoppingDetailScreen',
      builder: (_, state) => const ShoppingDetailScreen(),
      routes: [
        GoRoute(
          path: 'payment',
          name: 'ShoppingPayment',
          builder: (_, state) => const ShoppingPayment(),
        ),
      ],
    ),
    GoRoute(
      path: '/cart',
      name: 'ShoppingCartScreen',
      builder: (_, state) => const ShoppingCartScreen(),
    ),
    GoRoute(
      path: '/community/detail/:id',
      name: 'CommunityDetailScreen',
      builder:
          (_, state) => CommunityDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/community/create',
      name: 'CommunityCreateScreen',
      builder: (_, state) {
        String recipe_name = state.extra as String;
        return CommunityCreateScreen(recipe_name : recipe_name);
      },
      routes: [
        GoRoute(
          path: 'tag',
          name: 'CommunityCreateRecipeTagScreen',
          builder: (_, state) {
            final nextModel = state.extra as CommunityNextUploadModel;
            return CommunityCreateRecipeTagScreen(nextModel: nextModel);
          },
        ),
        GoRoute(
          path: 'upload',
          name: 'CommunityCreateUploadScreen',
          builder: (_, state) {
            final data = state.extra as CommunityUploadRecipeFinalListModel;
            return CommunityCreateUploadScreen(data: data);
          },
        ),
      ],
    ),
  ];

  void logout() {
    ref.read(userProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);

    final login = state.matchedLocation == '/login';
    final isSignup = state.matchedLocation == '/login/signup'; // 회원가입도 예외처리

    if (user == null) {
      return (login || isSignup) ? null : '/login';
    }

    if (user is UserModel) {
      return login || state.matchedLocation == '/splash' ? '/' : null;
    }
    return null;
  }
}

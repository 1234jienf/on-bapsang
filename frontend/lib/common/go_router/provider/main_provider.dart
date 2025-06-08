import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/view/splash_screen.dart';
import 'package:frontend/community/view/community_create_recipe_tag_screen.dart';
import 'package:frontend/community/view/community_create_screen.dart';
import 'package:frontend/community/view/community_create_upload_screen.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:frontend/community/view/community_root_screen.dart';
import 'package:frontend/home/view/home_alarm_screen.dart';
import 'package:frontend/home/view/home_cart_screen.dart';
import 'package:frontend/home/view/home_menu_screen.dart';
import 'package:frontend/maps/view/maps_root_screen.dart';
import 'package:frontend/mypage/view/mypage_root_screen.dart';
import 'package:frontend/recipe/view/recipe_root_screen.dart';
import 'package:frontend/recipe/view/recipe_detail_screen.dart';
import 'package:frontend/search/view/search_root_screen.dart';
import 'package:frontend/shopping/view/shopping_root_screen.dart';
import 'package:frontend/signup/view/sign_up_root_screen.dart';
import 'package:frontend/test_page.dart';
import 'package:frontend/user/view/login_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../home/view/home_page_screen.dart';
import '../../../search/search_detail/view/search_detail_root_screen.dart';
import '../../../search/view/search_main_screen.dart';
import '../../../shopping/view/shopping_detail/view/shopping_detail_screen.dart';
import '../../../signup/view/sign_up_food_prefer_list_screen.dart';
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
        GoRoute(
          path: 'prefer',
          name: 'SignUpFoodPreferListScreen',
          builder: (_, state) => SignUpFoodPreferListScreen(),
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
          builder: (_, state) => const HomePageScreen(),
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
              path: 'cart',
              name: 'HomeCartScreen',
              builder: (_, state) => const HomeCartScreen(),
            ),
            GoRoute(
              path: 'recipe',
              name: 'RecipeRootScreen',
              builder: (_, state) => const RecipeRootScreen(),
            ),
            GoRoute(
              path: 'shopping',
              name: 'shopping',
              builder: (_, state) => const ShoppingRootScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  name: 'ShoppingDetailScreen',
                  builder: (_, state) => const ShoppingDetailScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'community',
              name: 'community',
              builder: (_, state) => const CommunityRootScreen(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  name: 'CommunityDetailScreen',
                  builder:
                      (_, state) => CommunityDetailScreen(
                        id: state.pathParameters['id']!,
                      ),
                ),
                GoRoute(
                  path: 'create',
                  name: 'CommunityCreateScreen',
                  builder: (_, state) => const CommunityCreateScreen(),
                ),
                GoRoute(
                  path: 'tag',
                  name: 'CommunityCreateRecipeTagScreen',
                  builder: (_, state) => CommunityCreateRecipeTagScreen(),
                ),
                GoRoute(
                  path: 'upload',
                  name: 'CommunityCreateUploadScreen',
                  builder: (_, state) => const CommunityCreateUploadScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'maps',
              name: 'maps',
              builder: (_, state) => const MapsRootScreen(),
            ),
            GoRoute(
              path: 'search',
              name: 'SearchMainScreen',
              builder: (_, state) => const SearchMainScreen(),
              routes: [
                GoRoute(
                  path: 'detail',
                  name: 'SearchDetailRootScreen',
                  builder: (_, state) => const SearchDetailRootScreen(),
                ),
                GoRoute(
                  path: 'result',
                  name: 'SearchRootScreen',
                  builder: (_, state) => const SearchRootScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'mypage',
              name: 'MypageRootScreen',
              builder: (_, state) => const MypageRootScreen(),
            ),
          ],
        ),
      ],
    ),

    // GoRoute(path: '/test', name: 'Test', builder: (_, state) => TestPage()),


    // navbar 사용 안함
    GoRoute(
      path: '/recipe/detail/:id',
      name: 'RecipeDetailScreen',
      builder:
          (_, state) => RecipeDetailScreen(id: state.pathParameters['id']!),
    ),
  ];

  void logout() {
    ref.read(userProvider.notifier).logout();
  }

  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userProvider);

    final login = state.matchedLocation == '/login';

    if (user == null) {
      return login ? null : '/login';
    }

    if (user is UserModel) {
      return login || state.matchedLocation == '/splash' ? '/' : null;
    }
    return null;
  }
}

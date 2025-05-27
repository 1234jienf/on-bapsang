import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/view/community_create_screen.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:frontend/community/view/community_root_screen.dart';
import 'package:frontend/maps/view/maps_root_screen.dart';
import 'package:frontend/recipe/view/recipe_root_screen.dart';
import 'package:frontend/search/view/search_root_screen.dart';
import 'package:frontend/shopping/view/shopping_root_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../home/view/home_page_screen.dart';
import '../../../search/view/search_main_screen.dart';
import '../../view/root_tab.dart';

final mainProvider = ChangeNotifierProvider<MainProvider>((ref) {
  return MainProvider(ref: ref);
});

class MainProvider extends ChangeNotifier {
  final Ref ref;

  MainProvider({required this.ref}) {
    notifyListeners();
  }

  List<RouteBase> get routes => [
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
              path: 'recipe',
              name: 'recipe',
              builder: (_, state) => const RecipeRootScreen(),
            ),
            GoRoute(
              path: 'shopping',
              name: 'shopping',
              builder: (_, state) => const ShoppingRootScreen(),
            ),
            GoRoute(
              path: 'community',
              name: 'community',
              builder: (_, state) => const CommunityRootScreen(),
              routes: [
                GoRoute(
                  path: 'detail/:id',
                  name: 'CommunityDetailScreen',
                  builder: (_, state) => CommunityDetailScreen(id: state.pathParameters['id']!),
                ),
                GoRoute(
                  path: 'create',
                  name: 'CommunityCreateScreen',
                  builder: (_, state) => const CommunityCreateScreen(),
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
                  path: 'result',
                  name: 'SearchRootScreen',
                  builder: (_, state) => const SearchRootScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ];

  String? redirectLogic(BuildContext context, GoRouterState state) {
    // TODO :: 로그인 로직 완성되면 Provider로 다시 리펙토링 할 것
    final isLoggin = false;

    final loggingIn = state.matchedLocation == '/login';

    if (!isLoggin && !loggingIn) {
      return null;
    }

    return null;
  }
}

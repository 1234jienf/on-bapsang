import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/view/search_root_screen.dart';
import 'package:go_router/go_router.dart';

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

  List<GoRoute> get routes => [
    GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, state) => RootTab(),
      routes: [
        GoRoute(
          path: 'search',
          name: SearchMainScreen.routeName,
          builder: (_, state) => SearchMainScreen(),
          routes: [
            GoRoute(
              path: 'recipe',
              name: SearchRootScreen.routeName,
              builder: (_, state) => SearchRootScreen(),
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

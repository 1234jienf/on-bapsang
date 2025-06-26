import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/common/layout/default_layout.dart';

class RootTab extends StatelessWidget {
  const RootTab({super.key, required this.child});

  final Widget child;

  static const _paths = ['/', '/recipe', '/shopping', '/community', '/maps'];

  // location → index
  int _indexFromLocation(String loc) {
    if (loc.startsWith('/recipe')) return 1;
    if (loc.startsWith('/shopping')) return 2;
    if (loc.startsWith('/community')) return 3;
    if (loc.startsWith('/maps')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final String loc = GoRouterState.of(context).uri.toString();
    final int currentIndex = _indexFromLocation(loc);

    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        onTap: (i) => context.go(_paths[i]),
        items: [
          _navItem(
            'asset/img/home.png',
            'asset/img/home_color.png',
            '홈',
            currentIndex == 0,
          ),
          _navItem(
            'asset/img/recipe.png',
            'asset/img/recipe_color.png',
            '레시피',
            currentIndex == 1,
          ),
          _navItem(
            'asset/img/shopping.png',
            'asset/img/shopping_color.png',
            '쇼핑',
            currentIndex == 2,
          ),
          _navItem(
            'asset/img/community.png',
            'asset/img/community_color.png',
            '커뮤',
            currentIndex == 3,
          ),
          _navItem(
            'asset/img/map.png',
            'asset/img/map_color.png',
            '주변',
            currentIndex == 4,
          ),
        ],
      ),
      child: child,
    );
  }

  BottomNavigationBarItem _navItem(
    String off,
    String on,
    String label,
    bool selected,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        selected ? on : off,
        width: 24,
        height: 24
      ),
      label: label,
    );
  }
}

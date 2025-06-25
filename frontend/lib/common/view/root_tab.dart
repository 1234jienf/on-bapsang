import 'package:flutter/material.dart';
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
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        onTap: (i) => context.go(_paths[i]),
        items: [
          _navItem('asset/img/Union.png',          'asset/img/house-color.png',        '홈',   currentIndex == 0),
          _navItem('asset/img/Subtract.png',       'asset/img/chef-hat.png',           '레시피', currentIndex == 1),
          _navItem('asset/img/local_mall.png',     'asset/img/local_mall-color.png',   '쇼핑', currentIndex == 2),
          _navItem('asset/img/messages-square.png','asset/img/messages-square-color.png','커뮤', currentIndex == 3),
          _navItem('asset/img/map.png',            'asset/img/map-color.png',          '주변', currentIndex == 4),
        ],
      ),
      child: child,
    );
  }

  BottomNavigationBarItem _navItem(
      String off, String on, String label, bool selected) {
    return BottomNavigationBarItem(
      icon: Image.asset(selected ? on : off),
      label: label,
    );
  }
}

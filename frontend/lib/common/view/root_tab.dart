import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:go_router/go_router.dart';

class RootTab extends StatefulWidget {
  static String get routeName => 'home';
  final Widget child;

  const RootTab({super.key, required this.child});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabPaths = [
    '/',
    '/recipe',
    '/shopping',
    '/community',
    '/maps',
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTabIndex();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabIndex() {
    final String location = GoRouterState.of(context).uri.toString();
    int index = -1;

    // 정확한 매칭 로직
    if (location == '/') {
      index = 0;
    } else if (location.startsWith('/recipe')) {
      index = 1;
    } else if (location.startsWith('/shopping')) {
      index = 2;
    } else if (location.startsWith('/community')) {
      index = 3;
    } else if (location.startsWith('/maps')) {
      index = 4;
    }

    if (index != -1 && index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedFontSize: 12,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
          _tabController.animateTo(index);
          context.go(_tabPaths[index]);
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '레시피',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: '쇼핑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: '커뮤',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: '주변'),
        ],
      ),

      child: widget.child,
    );
  }
}

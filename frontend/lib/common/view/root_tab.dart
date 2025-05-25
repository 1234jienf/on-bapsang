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
  final List<String> _tabPaths = ['/', '/recipe', '/shopping', '/community', '/maps', '/search', '/search/result'];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTabIndex();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _updateTabIndex() {
    final String location = GoRouterState.of(context).uri.toString();
    final int index = _tabPaths.indexWhere((path) => location.startsWith(path));
    if (index != -1 && _tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;

    final String targetPath = _tabPaths[_tabController.index];
    final String currentLocation = GoRouterState.of(context).uri.toString();

    if (currentLocation != targetPath) {
      context.go(targetPath);
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
          _tabController.animateTo(index, duration: Duration(milliseconds: 300));
        },
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: '레시피'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket_outlined),
            label: '쇼핑',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: '커뮤',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: '주변',
          ),
        ],
      ),

      child: widget.child,
    );
  }
}

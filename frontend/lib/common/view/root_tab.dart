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
        backgroundColor: Colors.white,
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
          BottomNavigationBarItem(
            icon: _buildIcon(
              path: 'asset/img/Union.png',
              pathColor: 'asset/img/house-color.png',
              isSelected: currentIndex == 0,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              path: 'asset/img/Subtract.png',
              pathColor: 'asset/img/chef-hat.png',
              isSelected: currentIndex == 1,
            ),
            label: '레시피',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              path: 'asset/img/local_mall.png',
              pathColor: 'asset/img/local_mall-color.png',
              isSelected: currentIndex == 2,
            ),
            label: '쇼핑',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              path: 'asset/img/messages-square.png',
              pathColor: 'asset/img/messages-square-color.png',
              isSelected: currentIndex == 3,
            ),
            label: '커뮤',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(
              path: 'asset/img/map.png',
              pathColor: 'asset/img/map-color.png',
              isSelected: currentIndex == 4,
            ),
            label: '주변',
          ),
        ],
      ),

      child: widget.child,
    );
  }

  Widget _buildIcon({
    required String path,
    required String pathColor,
    required bool isSelected,
  }) {
    return Image.asset(isSelected ? pathColor : path);
  }
}

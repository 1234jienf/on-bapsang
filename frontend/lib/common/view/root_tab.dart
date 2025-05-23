import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    _tabController.dispose();
    super.dispose();
  }

  void tabListener() {
    setState(() {
      currentIndex = _tabController.index;
    });
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
          _tabController.animateTo(index);
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
      title: 'On-Bapsang',
      child: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(child: Text('home')),
          Center(child: Text('receipt')),
          Center(child: Text('shopping')),
          Center(child: Text('commu')),
          Center(child: Text('maps')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_community/view/search_community_screen.dart';
import 'package:frontend/search/search_product/view/search_product_screen.dart';
import 'package:frontend/search/search_recipe/view/search_recipe_screen.dart';
import 'package:frontend/search/serach_merged/view/search_merged_screen.dart';
import 'package:go_router/go_router.dart';

import '../common/search_recipe_filter_header.dart';
import '../component/search_app_bar.dart';
import '../component/search_recipe_filter_bar.dart';
import '../provider/search_tab_index_provider.dart';
import '../common/search_bottom_filter.dart';

class SearchRootScreen extends ConsumerStatefulWidget {
  const SearchRootScreen({super.key});

  static String get routeName => 'SearchRootScreen';

  @override
  ConsumerState<SearchRootScreen> createState() => _SearchRootScreenState();
}

class _SearchRootScreenState extends ConsumerState<SearchRootScreen> {
  late PageController _pageController = PageController();
  final double menuGap = 10.0;
  final List<String> tabs = ['통합','레시피', '상품', '커뮤니티'];

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(searchTabIndexProvider);
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {

    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchTabIndexProvider);
    final String name = GoRouterState.of(context).extra as String;

    return DefaultLayout(
      appBar: SearchAppBar(),
      child: Padding(
        // 전체 패딩 갭
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            _menuBar(state),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {ref.read(searchTabIndexProvider.notifier).setIndex(index);},
                children: [
                  const SearchMergedScreen(),
                  SearchRecipeScreen(name : name),
                  SearchProductScreen(),
                  SearchCommunityScreen(name : name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuBar(int selectedIndex) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 6.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(tabs.length, (index) {
              final isSelected = index == selectedIndex;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: menuGap),
                child: GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              );
            }),
          ),
          const Divider(thickness: 0.5, color: Colors.black),
          _selected(selectedIndex)
        ],
      ),
    );
  }

  Widget _selected(int selectedIndex) {
    return selectedIndex == 0 ? SizedBox() : selectedIndex == 1 ? SearchRecipeFilterBar() : SearchRecipeFilterHeader(bottomFilter: SearchBottomFilter());
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_community/view/search_community_screen.dart';
import 'package:frontend/search/search_product/view/search_product_screen.dart';
import 'package:frontend/search/search_recipe/view/search_recipe_screen.dart';

import '../component/search_app_bar.dart';
import '../provider/search_tab_index_provider.dart';

class SearchRootScreen extends ConsumerStatefulWidget {
  const SearchRootScreen({super.key});

  static String get routeName => 'SearchRootScreen';

  @override
  ConsumerState<SearchRootScreen> createState() => _SearchRootScreenState();
}

class _SearchRootScreenState extends ConsumerState<SearchRootScreen> {
  final PageController _pageController = PageController();
  final double menuGap = 10.0;
  final List<String> tabs = ['레시피', '상품', '커뮤니티'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchTabIndexProvider);
    return DefaultLayout(
      appBar: SearchAppBar(),
      child: Padding(
        // 전체 패딩 갭
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            _menuBar(state),
            const Divider(thickness: 0.5, color: Colors.black),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  ref.read(searchTabIndexProvider.notifier).setIndex(index);
                },
                children: const [
                  SearchRecipeScreen(),
                  SearchProductScreen(),
                  SearchCommunityScreen(),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(tabs.length, (index) {
          final isSelected = index == selectedIndex;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: menuGap),
            child: GestureDetector(
              onTap: () {
                ref.read(searchTabIndexProvider.notifier).setIndex(index);
                _pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 200),
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
    );
  }
}

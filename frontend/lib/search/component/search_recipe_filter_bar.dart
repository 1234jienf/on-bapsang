import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/search/component/search_recipe_filter_type.dart';

import '../../common/const/colors.dart';
import '../common/search_bottom_filter.dart';
import '../common/search_recipe_filter_header.dart';
import '../common/search_top_filter.dart';
import '../search_recipe/component/search_recipe_icon.dart';
import '../search_recipe/component/search_recipe_options.dart';
import '../search_recipe/provider/search_filter_tab_index_provider.dart';

class SearchRecipeFilterBar extends ConsumerStatefulWidget {
  const SearchRecipeFilterBar({super.key});

  @override
  ConsumerState<SearchRecipeFilterBar> createState() => _ConsumerSearchRecipeFilterBarState();
}

class _ConsumerSearchRecipeFilterBarState extends ConsumerState<SearchRecipeFilterBar> {
  final List<String> tabs = ['종류', '조리법', '필수 식재료'];
  late PageController _pageController = PageController();
  final double menuGap = 10.0;

  @override
  void initState() {
    super.initState();
    final initialIndex = ref.read(searchFilterTabIndexProvider);
    _pageController = PageController(initialPage: initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchFilterTabIndexProvider);

    return SearchRecipeFilterHeader(
      topFilter: SearchTopFilter(
        recipeTypeIcon: SearchRecipeIcon(title: '필터'),
        recipeTypeOptions: SearchRecipeOptions(
          title: '필터',
          options: _typeOptions(state),
        ),
      ),
      bottomFilter: SearchBottomFilter(),
    );
  }

  Widget _typeOptions(int state) {
    return Center(
      child: Column(
        children: [
          _menuBar(),
          SizedBox(
            height: 300,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {ref.read(searchFilterTabIndexProvider.notifier).setIndex(index);},
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: 300,
                    child: SearchRecipeFilterType(),
                  ),
                ),
                Center(child: Text('기능 추가 예정입니다'),),
                Center(child: Text('기능 추가 예정입니다'),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuBar() {
    return Consumer(
      builder: (context, ref, child) {
        final selectedIndex = ref.watch(searchFilterTabIndexProvider);

        return Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 6.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(tabs.length, (index) {
                  final bool isSelected = index == selectedIndex;

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
              const Divider(thickness: 0.5, color: gray600),
            ],
          ),
        );
      },
    );
  }

}

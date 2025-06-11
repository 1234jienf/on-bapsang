import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_detail/view/search_detail_ingredient_screen.dart';
import 'package:frontend/search/search_detail/view/search_detail_recipe_screen.dart';
import 'package:frontend/search/search_detail/view/search_detail_variety_screen.dart';

import '../common/search_detail_next_bar.dart';
import '../common/search_detail_app_bar.dart';
import '../provider/search_detail_tab_index_provider.dart';

class SearchDetailRootScreen extends ConsumerStatefulWidget {
  static String get routeName => 'SearchDetailRootScreen';

  const SearchDetailRootScreen({super.key});

  @override
  ConsumerState<SearchDetailRootScreen> createState() =>
      _ConsumerSearchDetailRootScreenState();
}

class _ConsumerSearchDetailRootScreenState
    extends ConsumerState<SearchDetailRootScreen> {
  final List<String> tabs = ['종류 선택', '조리법 선택', '식재료 선택'];

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(searchDetailTabIndexProvider);
    final provider = ref.read(searchDetailTabIndexProvider.notifier);

    return DefaultLayout(

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchDetailAppBar(title: tabs[index], index: index, provider : provider),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final stepWidth = width / 3;

                return Stack(
                  children: [
                    // 배경 바
                    Container(
                      height: 8,
                      width: width,
                      decoration: BoxDecoration(color: Color(0xEEEEEEEE)),
                    ),
                    // 진행 바
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: stepWidth * index,
                      child: Container(
                        width: stepWidth,
                        height: 8,
                        decoration: BoxDecoration(color: Colors.black),
                      ),
                    ),
                  ],
                );
              },
            ),
            index == 0
                ? SearchDetailVarietyScreen()
                : index == 1
                ? SearchDetailRecipeScreen()
                : SearchDetailIngredientScreen(),

            SearchDetailNextBar(
              title: '다음',
              provider: provider,
            ),
          ],
        ),
      ),
    );
  }
}

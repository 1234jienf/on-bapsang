import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/provider/search_keyword_remian_provider.dart';
import 'package:frontend/search/view/search_root_screen.dart';
import 'package:go_router/go_router.dart';

import '../component/search_app_bar.dart';
import '../provider/search_keyword_provider.dart';

class SearchMainScreen extends ConsumerStatefulWidget {
  static String get routeName => 'SearchMainScreen';

  const SearchMainScreen({super.key});

  @override
  ConsumerState<SearchMainScreen> createState() => _ConsumerSearchMainScreenState();
}

class _ConsumerSearchMainScreenState extends ConsumerState<SearchMainScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(searchKeywordRemainProvider.notifier).clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchKeywordProvider);

    final items = [
      '김치찌개',
      '된장찌개',
      '참치찌개',
      '어묵탕',
      '부대찌개',
      '계란찜',
      '오징어 볶음',
      '감자탕',
      '고등어조림',
      '갈비탕',
    ];


    if (state.popular == null || state.recent == null) {
      return DefaultLayout(
        appBar: SearchAppBar(hintText: '레시피를 검색해주세요'),
        child: Center(child: CircularProgressIndicator()),
      );
    }


    return DefaultLayout(
      appBar: SearchAppBar(hintText: ''),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 16.0),
        child: Column(
          children: [
            _searchTitle(title: '최근 검색어'),
            _recentSearch(items: state.recent!, context: context, ref : ref),
            _searchTitle(title: '인기 검색어'),
            _famousSearch(items: state.popular!, ref : ref, context: context),
            _searchTitle(
              title: '온밥 추천 검색어',
              icon: Icon(Icons.info_outline_rounded, size: 18.0),
            ),
            _recommandSearch(items: items, context: context, ref : ref),
            // 배너
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Image.asset('asset/img/search_banner.png'),
            ),
          ],
        ),
      ),
    );
  }
}

Padding _recommandSearch({required List<String> items, required BuildContext context, required WidgetRef ref}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16.0),
    child: SizedBox(
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 10.0,
        runSpacing: 10.0,
        children: List.generate(8, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 66, maxWidth: 80),
              child: GestureDetector(
                onTap: () {
                  ref.read(searchKeywordRemainProvider.notifier).setKeyword(items[index]);
                  context.pushNamed(SearchRootScreen.routeName, extra: items[index]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: Text(
                      items[index],
                      style: TextStyle(fontSize: 13.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}

Widget _searchTitle({required String title, String? subtitle, Icon? icon}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (subtitle == null && icon != null)
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 5.0),
            icon,
          ],
        ),
      if (icon == null)
        Text(
          title,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
        ),
      if (subtitle != null)
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
    ],
  );
}

Padding _famousSearch({required List<String> items, required WidgetRef ref, required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.only(top: 6.0, bottom: 26.0),
    child: Column(
      children: List.generate((items.length / 2).ceil(), (index) {
        final leftIndex = index * 2;
        final rightIndex = leftIndex + 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref.read(searchKeywordRemainProvider.notifier).setKeyword(items[leftIndex]);
                    context.pushNamed(SearchRootScreen.routeName, extra: items[leftIndex]);
                  },
                  child: Text(
                    '${leftIndex + 1}. ${items[leftIndex]}',
                    style: TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: rightIndex < items.length
                    ? GestureDetector(
                  onTap: () {
                    ref.read(searchKeywordRemainProvider.notifier).setKeyword(items[rightIndex]);
                    context.pushNamed(SearchRootScreen.routeName, extra: items[rightIndex]);
                  },
                  child: Text(
                    '${rightIndex + 1}. ${items[rightIndex]}',
                    style: TextStyle(fontSize: 14.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
                    : SizedBox()
              ),
            ],
          ),
        );
      }),
    ),
  );
}

Padding _recentSearch({required List<String> items, required BuildContext context, required WidgetRef ref}) {
  return Padding(
    padding: const EdgeInsets.only(top: 13.0, bottom: 26.0),
    child: SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                ref.read(searchKeywordRemainProvider.notifier).setKeyword(items[index]);
                context.pushNamed(SearchRootScreen.routeName, extra: items[index]);
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.grey),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: [
                    Text(items[index], style: TextStyle(fontSize: 13.0)),
                    const SizedBox(width: 5.0),
                    Icon(Icons.close_outlined, size: 16.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

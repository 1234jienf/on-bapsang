import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import '../component/search_app_bar.dart';

class SearchMainScreen extends StatelessWidget {
  static String get routeName => 'SearchMainScreen';

  const SearchMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return DefaultLayout(
      appBar: SearchAppBar(hintText: '레시피를 검색해주세요'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 16.0),
        child: Column(
          children: [
            _searchTitle(title: '최근 검색어', subtitle: '모두 지우기'),
            _recentSearch(items: items),
            _searchTitle(title: '인기 검색어'),
            _famousSearch(items: items),
            _searchTitle(
              title: '온밥 추천 검색어',
              icon: Icon(Icons.info_outline_rounded, size: 18.0),
            ),
            _recommandSearch(items: items),
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

Padding _recommandSearch({required List<String> items}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: SizedBox(
      height: 80,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        spacing: 10.0,
        runSpacing: 10.0,
        children: List.generate(8, (index) {
          return ConstrainedBox(
            constraints: BoxConstraints(minWidth: 66, maxWidth: 80),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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

Padding _famousSearch({required List<String> items}) {
  return Padding(
    padding: const EdgeInsets.only(top: 6.0, bottom: 26.0),
    child: Column(
      children: List.generate(5, (index) {
        final leftIndex = index * 2;
        final rightIndex = leftIndex + 1;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 항목
              Expanded(
                child: Text(
                  '${leftIndex + 1}. ${items[leftIndex]}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
              // 오른쪽 항목
              Expanded(
                child: Text(
                  '${rightIndex + 1}. ${items[rightIndex]}',
                  style: TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );
}

Padding _recentSearch({required List<String> items}) {
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
          );
        },
      ),
    ),
  );
}

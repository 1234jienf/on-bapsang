import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';

import '../search_recipe/provider/search_filter_apply_provider.dart';

class SearchRecipeFilterType extends ConsumerWidget {
  SearchRecipeFilterType({super.key});

  final items = [
    '소고기',
    '돼지고기',
    '가공식품류',
    '콩/견과류',
    '채소류',
    '버섯류',
    '과일류',
    '쌀',
    '달걀/유제품',
    '밀가루',
    '해물류',
    '건어물류',
    '곡류',
    '기타',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(searchFilterApplyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (selectedItems.isEmpty) Container(height: 29,),
              ...selectedItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: primaryColor,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      color: primaryColor
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item,
                          style: TextStyle(
                            fontSize: 13.0,
                            color: gray000
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        GestureDetector(
                          onTap: () {ref.read(searchFilterApplyProvider.notifier).toggle(item);},
                          child: Icon(
                            Icons.close_outlined,
                            size: 16.0,
                            color: gray000
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children:
                items.map((item) {
                  final isSelected = selectedItems.contains(item);
                  return GestureDetector(
                    onTap: () {
                      ref.read(searchFilterApplyProvider.notifier).toggle(item);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.black : gray400,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        color: isSelected ? Colors.black : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

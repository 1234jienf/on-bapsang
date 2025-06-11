import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../provider/search_detail_tab_index_provider.dart';

class SearchDetailAppBar extends StatelessWidget {
  final int index;
  final String title;
  final SearchDetailTabIndexNotifier provider;

  const SearchDetailAppBar({
    super.key,
    required this.title,
    required this.index,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (index == 0) {
                  context.pop();
                } else {
                  provider.setIndexDown();
                }
              },
              child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/search_detail_tab_index_provider.dart';

class SearchDetailNextBar extends ConsumerStatefulWidget {
  final String title;
  final SearchDetailTabIndexNotifier provider;

  const SearchDetailNextBar({
    super.key,
    required this.provider,
    required this.title,
  });

  @override
  ConsumerState<SearchDetailNextBar> createState() => _ConsumerSearchDetailNextBarState();
}

class _ConsumerSearchDetailNextBarState extends ConsumerState<SearchDetailNextBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.provider.setIndexUp();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black,
        ),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

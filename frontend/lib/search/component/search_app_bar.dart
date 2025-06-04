import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../search_detail/view/search_detail_root_screen.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchAppBar({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(48.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 55,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        margin: const EdgeInsets.only(right: 12.0),
        width: 325,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(8.0),
        ),
        alignment: Alignment.center,
        child: TextField(
          decoration: InputDecoration(
            hintText: '레시피를 검색해주세요',

            hintStyle: TextStyle(fontSize: 14.0),
            filled: true,
            isCollapsed: true,
            fillColor: Colors.grey[100],
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onSubmitted: (value) {
            context.pushNamed(SearchDetailRootScreen.routeName);
          },
        ),
      ),
    );
  }
}

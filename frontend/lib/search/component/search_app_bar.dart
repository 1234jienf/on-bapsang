import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchAppBar({
    super.key,
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
          controller: controller,
          onChanged: onChanged,
          decoration: const InputDecoration(
            hintText: '레시피를 검색해주세요',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            isCollapsed: true,
          ),
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }
}
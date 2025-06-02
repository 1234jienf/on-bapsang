import 'package:flutter/material.dart';

class RecipeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImply;
  const RecipeAppbar({super.key, required this.isImply});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: '레시피를 검색해보세요!',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (value) {
                  // 검색어 처리
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Icon(Icons.shopping_cart_outlined, size: 29),
        const SizedBox(width: 7),
        Icon(Icons.person_outline_outlined, size: 29),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

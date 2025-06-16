import 'package:flutter/material.dart';

import 'package:frontend/mypage/view/mypage_root_screen.dart';
import 'package:go_router/go_router.dart';

import '../../shopping/view/shopping_cart_screen.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImply;

  const HomeAppbar({super.key, required this.isImply});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      // 그림자 제거
      scrolledUnderElevation: 0,
      // 스크롤 후 변화 방지
      title: Text('On-Bapsang'),
      actions: [
        Icon(Icons.notifications_none_outlined, size: 26),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            context.pushNamed(ShoppingCartScreen.routeName);
          },
          child: Icon(Icons.shopping_cart_outlined, size: 26),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            context.pushNamed(MypageRootScreen.routeName);
          },
          child: Icon(Icons.person_outline_outlined, size: 26),
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

class MypageAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImply;
  const MypageAppbar({super.key, required this.isImply});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      title: Text('000님의 마이페이지'),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.logout_outlined, size: 29,))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

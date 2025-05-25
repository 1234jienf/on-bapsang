import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text('On-Bapsang'),
      actions: [
        Icon(Icons.notifications_none_outlined, size: 29),
        const SizedBox(width: 7),
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

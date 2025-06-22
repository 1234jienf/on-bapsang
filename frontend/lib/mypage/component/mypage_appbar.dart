import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/user/provider/user_provider.dart';

class MypageAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImply;
  final String name;

  const MypageAppbar({
    super.key,
    required this.isImply,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => AppBar(
        automaticallyImplyLeading: isImply,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text('$name님의 마이페이지'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(userProvider.notifier).logout();
            },
            icon: Icon(Icons.logout_outlined, size: 29),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


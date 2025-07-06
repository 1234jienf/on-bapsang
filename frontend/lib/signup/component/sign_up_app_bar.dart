import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const SignUpAppBar({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        '회원가입',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
      ),
      leading: GestureDetector(
        onTap: onBack,
        child: Icon(Icons.arrow_back_ios_new_outlined, size: 23),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';

class SearchDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const SearchDetailAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 55,
      automaticallyImplyLeading: false,
      leading: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}

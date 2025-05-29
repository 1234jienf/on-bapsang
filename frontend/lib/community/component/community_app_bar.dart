import 'package:flutter/material.dart';
import 'package:frontend/community/view/community_create_recipe_tag_screen.dart';
import 'package:frontend/community/view/community_create_upload_screen.dart';
import 'package:go_router/go_router.dart';

class CommunityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isFirst;
  final String title;
  final int index;
  final List<String> routeNames = [
    CommunityCreateRecipeTagScreen.routeName,
    CommunityCreateUploadScreen.routeName,
  ];
  final String next;

  CommunityAppBar({
    super.key,
    required this.index,
    required this.title,
    required this.next,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child:
            isFirst
                ? Icon(Icons.close_outlined)
                : Icon(Icons.arrow_back_ios_new_outlined),
      ),
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              context.pushNamed(routeNames[index]);
            },
            child: Text(
              next,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55.0);
}

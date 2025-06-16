import 'package:flutter/material.dart';
import 'package:frontend/home/view/home_menu_screen.dart';
import 'package:frontend/mypage/view/mypage_root_screen.dart';
import 'package:frontend/search/view/search_main_screen.dart';
import 'package:frontend/shopping/view/shopping_cart_screen.dart';
import 'package:go_router/go_router.dart';

class RecipeAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isImply;
  const RecipeAppbar({super.key, required this.isImply});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 0,
      leading: IconButton(
          onPressed: (){
            context.pushNamed(HomeMenuScreen.routeName);
          },
          icon: Icon(Icons.menu, size: 29)
      ),
      title: GestureDetector(
        onTap: () {
          context.pushNamed(SearchMainScreen.routeName);
        },
        child: Container(
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
                child: Text(
                  '레시피를 검색해보세요!',
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        const SizedBox(width: 7),
        // 알림 들어가는지 확인필요
        // GestureDetector(
        //   onTap: () {
        //     context.pushNamed(HomeAlarmScreen.routeName);
        //   },
        //   child: Icon(Icons.notifications_none_outlined, size: 29)
        // ),
        const SizedBox(width: 7),
        GestureDetector(
            onTap: () {
              context.pushNamed(ShoppingCartScreen.routeName);
            },
            child: Icon(Icons.shopping_cart_outlined, size: 29)
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: (){
            context.pushNamed(
              MypageRootScreen.routeName,
            );
          },
          child: Icon(Icons.person_outline_outlined, size: 29),
        ),
        const SizedBox(width: 9),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

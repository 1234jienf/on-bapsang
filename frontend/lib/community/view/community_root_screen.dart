import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/view/community_create_screen.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:go_router/go_router.dart';

import '../../common/appbar/home_appbar.dart';
import '../../home/component/community_card.dart';
import '../../search/common/search_recipe_filter.dart';

class CommunityRootScreen extends StatefulWidget {
  const CommunityRootScreen({super.key});

  @override
  State<CommunityRootScreen> createState() => _CommunityRootScreenState();
}

class _CommunityRootScreenState extends State<CommunityRootScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: HomeAppbar(isImply: false,),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(CommunityCreateScreen.routeName);
        },
        heroTag: "actionButton",
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 24, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          controller: controller,
          slivers: [
            SearchRecipeFilter(isTopFilter: false),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (_, index) => GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      CommunityDetailScreen.routeName,
                      pathParameters: {'id': '123'},
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: CommunityCard(userName: "user_0011"),
                  ),
                ),
                childCount: 10,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 175 / 255,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

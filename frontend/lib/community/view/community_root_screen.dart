import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

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
      appBar: HomeAppbar(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ExcludeSemantics(
          child: CustomScrollView(
            controller: controller,
            slivers: [
              SearchRecipeFilter(isTopFilter: false),
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: CommunityCard(userName: "user_0011"),
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
      ),
    );
  }
}

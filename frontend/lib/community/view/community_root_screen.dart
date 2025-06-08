import 'package:flutter/material.dart';
import 'package:frontend/common/component/pagination_int_grid_view.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/provider/community_provider.dart';
import 'package:frontend/community/view/community_create_screen.dart';
import 'package:go_router/go_router.dart';

import '../../common/appbar/home_appbar.dart';
import '../component/community_card.dart';
import 'community_detail_screen.dart';

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
      appBar: HomeAppbar(isImply: false),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(CommunityCreateScreen.routeName);
        },
        heroTag: "actionButton",
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 24, color: Colors.white),
      ),
      child: PaginationIntGridView(
        provider: communityProvider,
        itemBuilder: <CommunityModel>(_, index, model) {
          return GestureDetector(
            onTap: () {context.pushNamed(CommunityDetailScreen.routeName, pathParameters: {'id' : model.id.toString()});},
            child: CommunityCard.fromModel(model: model),
          );
        },
      ),
    );
  }
}

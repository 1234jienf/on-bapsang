import 'package:flutter/material.dart';
import 'package:frontend/common/component/pagination_int_grid_view.dart';
import 'package:frontend/community/provider/community_provider.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../community/component/community_card.dart';

class SearchCommunityScreen extends StatelessWidget {
  final String name;

  const SearchCommunityScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return PaginationIntGridView(
      childAspectRatio: 175 / 275,
      provider: communityProvider(CommunityParams(keyword: name, sort: 'desc')),
      itemBuilder: <CommunityModel>(_, index, model) {
        return GestureDetector(
          onTap: () {
            context.pushNamed(CommunityDetailScreen.routeName,
                pathParameters: {'id': model.id.toString()});
          },
          child: CommunityCard.fromModel(model: model),
        );
      },
    );
  }
}

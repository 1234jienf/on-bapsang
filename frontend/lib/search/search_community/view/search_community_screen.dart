import 'package:flutter/material.dart';
import 'package:frontend/common/component/pagination_int_grid_view.dart';
import 'package:frontend/community/provider/community_provider.dart';

import '../../../community/component/community_card.dart';


class SearchCommunityScreen extends StatelessWidget {
  const SearchCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationIntGridView(childAspectRatio : 175 / 275 , provider: communityProvider,
        itemBuilder: <CommunityModel>(_, index, model) {
          return GestureDetector(
            onTap: () {}, child: CommunityCard.fromModel(model: model),);
        });
  }
}


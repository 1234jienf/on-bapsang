import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/search/search_recipe/component/search_recipe_card.dart';

import '../../../common/component/pagination_string_list_view.dart';
import '../../model/search_recipe_model.dart';
import '../../provider/search_provider.dart';

class SearchRecipeScreen extends ConsumerWidget {
  final String name;
  const SearchRecipeScreen({super.key, required this.name});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return DefaultLayout(
      child: PaginationStringListView<SearchRecipeModel>(
        fetchCount: 10,
        provider: searchProvider(name),
        itemBuilder: <SearchRecipeModel>(_, index, model) {
          return SearchRecipeCard.fromModel(model: model);
        },
      ),
    );
  }
}

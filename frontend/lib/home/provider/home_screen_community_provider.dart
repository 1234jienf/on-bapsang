import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/single_int_state_notifier.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/home/repository/home_screen_community_repository.dart';

import '../../common/model/int/cursor_pagination_int_model.dart';

final homeScreenCommunityProvider = StateNotifierProvider<
  SingleIntStateNotifier<CommunityModel>,
  AsyncValue<CursorIntPagination<CommunityModel>>
>((ref) {
  final repo = ref.watch(homeScreenCommunityRepositoryProvider);

  return SingleIntStateNotifier<CommunityModel>(
    fetchFunction: () async {
      final response = await repo.fetchData();
      return response;
    },
  );
});

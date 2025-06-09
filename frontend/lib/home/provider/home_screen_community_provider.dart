import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/single_state_notifier.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/home/repository/home_screen_community_repository.dart';

final homeScreenCommunityProvider = StateNotifierProvider<
  SingleStateNotifier<CommunityModel>,
  AsyncValue<List<CommunityModel>>
>((ref) {
  final repo = ref.watch(homeScreenCommunityRepositoryProvider);

  return SingleStateNotifier<CommunityModel>(
    fetchFunction: () async {
      final response = await repo.fetchData(size: 6);
      return response.result.data;
    },
  );
});

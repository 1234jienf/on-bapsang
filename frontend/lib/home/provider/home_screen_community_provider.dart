import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/single_int_state_notifier.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/home/repository/home_screen_community_repository.dart';
import '../../common/model/wrapper/int_list_wrapper_response.dart';

final homeScreenCommunityProvider = StateNotifierProvider<
    SingleIntListStateNotifier<CommunityModel>,
    AsyncValue<IntListWrapperResponse<CommunityModel>>
>((ref) {
  final repo = ref.watch(homeScreenCommunityRepositoryProvider);

  return SingleIntListStateNotifier<CommunityModel>(
    fetchFunction: () async {
      final response = await repo.fetchData(size: 6);
      return response;
    },
  );
});

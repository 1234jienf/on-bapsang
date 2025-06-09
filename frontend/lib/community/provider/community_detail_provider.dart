import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/wrapper/int_data_wrapper_response.dart';
import 'package:frontend/common/provider/single_int_state_notifier.dart';
import 'package:frontend/community/model/community_detail_model.dart';
import 'package:frontend/community/repository/community_detail_repository.dart';

final communityDetailProvider = StateNotifierProvider.family<
    SingleIntDataStateNotifier<CommunityDetailModel>,
    AsyncValue<IntDataWrapperResponse<CommunityDetailModel>>,
  String
>((ref, id) {
  final repo = ref.watch(communityDetailRepositoryProvider);

  return SingleIntDataStateNotifier<CommunityDetailModel>(
    fetchFunction: () async {
      final response = await repo.fetchData(id: id);
      return response;
    },
  );
});

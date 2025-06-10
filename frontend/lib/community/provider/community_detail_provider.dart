import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/single_int_one_page_notifier.dart';
import 'package:frontend/community/model/community_detail_model.dart';
import 'package:frontend/community/repository/community_detail_repository.dart';

import '../../common/model/int/single_int_one_page_model.dart';

final communityDetailProvider = StateNotifierProvider.family<
    SingleIntOnePageNotifier<CommunityDetailModel>,
    AsyncValue<SingleIntOnePageModel<CommunityDetailModel>>,
  String
>((ref, id) {
  final repo = ref.watch(communityDetailRepositoryProvider);

  return SingleIntOnePageNotifier<CommunityDetailModel>(
    fetchFunction: () async {
      final response = await repo.fetchData(id: id);
      return response;
    },
  );

});

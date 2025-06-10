import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/model/int/single_int_one_page_model.dart';
import 'package:frontend/community/model/community_comment_model.dart';
import 'package:frontend/community/repository/community_detail_repository.dart';

import '../../common/provider/single_int_one_page_notifier.dart';

final communityCommentProvider = StateNotifierProvider.family<
    SingleIntOnePageNotifier<List<CommunityCommentModel>>,
  AsyncValue<SingleIntOnePageModel<List<CommunityCommentModel>>>,
  String
>((ref, id) {
  final repo = ref.watch(communityDetailRepositoryProvider);

  return SingleIntOnePageNotifier<List<CommunityCommentModel>>(
    fetchFunction: () async {
      final response = await repo.fetchComment(id: id);
      return response;
    },
  );
});

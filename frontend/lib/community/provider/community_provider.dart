import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/community/model/community_model.dart';
import 'package:frontend/community/repository/community_repository.dart';

import '../../common/provider/pagination_int_provider.dart';

final communityProvider = StateNotifierProvider((ref) {
  final repository = ref.watch(communityRepositoryProvider);
  final notifier = CommunityStateNotifier(repository: repository,);
  return notifier;
});

class CommunityStateNotifier
    extends PaginationIntProvider<CommunityModel, CommunityRepository> {
  CommunityStateNotifier({required super.repository});

}

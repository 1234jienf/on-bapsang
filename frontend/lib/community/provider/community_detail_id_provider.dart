import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityDetailIdProvider = StateNotifierProvider<CommunityDetailIdNotifier, String>((ref) {
  return CommunityDetailIdNotifier();
});

class CommunityDetailIdNotifier extends StateNotifier<String> {
  CommunityDetailIdNotifier() : super("");

  void setId(String id) {
    state = id;
  }
}
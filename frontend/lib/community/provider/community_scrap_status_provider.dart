import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'community_detail_provider.dart';

// Provider 정의
final communityScrapStatusProvider = StateNotifierProvider.family<
    CommunityScrapStatusNotifier,
    ScrapStatus,
    String>((ref, id) {
  final detail = ref.watch(communityDetailProvider(id)).value?.data;

  final scrapped = detail?.scrapped ?? false;
  final scrapCount = detail?.scrapCount ?? 0;

  return CommunityScrapStatusNotifier(
    scrapped: scrapped,
    scrapCount: scrapCount,
  );
});

class ScrapStatus {
  final bool scrapped;
  final int scrapCount;

  const ScrapStatus({
    required this.scrapped,
    required this.scrapCount,
  });

  ScrapStatus copyWith({
    bool? scrapped,
    int? scrapCount,
  }) {
    return ScrapStatus(
      scrapped: scrapped ?? this.scrapped,
      scrapCount: scrapCount ?? this.scrapCount,
    );
  }

}

// StateNotifier 클래스
class CommunityScrapStatusNotifier extends StateNotifier<ScrapStatus> {
  CommunityScrapStatusNotifier({
    required bool scrapped,
    required int scrapCount,
  }) : super(ScrapStatus(scrapped: scrapped, scrapCount: scrapCount));

  void toggle() {
    final newScrapped = !state.scrapped;
    final newScrapCount = newScrapped
        ? state.scrapCount + 1
        : state.scrapCount - 1;

    final validScrapCount = newScrapCount < 0 ? 0 : newScrapCount;

    state = state.copyWith(
      scrapped: newScrapped,
      scrapCount: validScrapCount,
    );
  }
}

class ScrapStatusParam {
  final String id;
  final bool scrapped;
  final int scrapCount;

  const ScrapStatusParam({
    required this.id,
    required this.scrapped,
    required this.scrapCount,
  });


  ScrapStatusParam copyWith({
    String? id,
    bool? scrapped,
    int? scrapCount,
  }) {
    return ScrapStatusParam(
      id: id ?? this.id,
      scrapped: scrapped ?? this.scrapped,
      scrapCount: scrapCount ?? this.scrapCount,
    );
  }
}
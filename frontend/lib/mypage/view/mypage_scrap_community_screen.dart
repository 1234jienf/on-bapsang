import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/component/pagination_int_grid_view.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_card.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:frontend/mypage/provider/mypage_community_provider.dart';
import 'package:go_router/go_router.dart';


// 테스트 필요
class MypageScrapCommunityScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageScrapCommunityScreen';

  const MypageScrapCommunityScreen({super.key});

  @override
  ConsumerState<MypageScrapCommunityScreen> createState() => _MypageScrapCommunityScreenState();
}

class _MypageScrapCommunityScreenState extends ConsumerState<MypageScrapCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        appBar: AppBar(
          title: Text('내가 스크랩한 글'),
          backgroundColor: Colors.white,
        ),
        child: PaginationIntGridView(
          provider: mypageScrapCommunityProvider(
            CommunityParams(keyword: null, sort: 'desc'),
          ),
          itemBuilder: <MypageCommunityModel>(_, index, model) {
            return GestureDetector(
              onTap: () {
                context.pushNamed(
                  CommunityDetailScreen.routeName,
                  pathParameters: {'id': model.id.toString()},
                );
              },
              child: CommunityCard.fromModel(model: model.toCommunityModel()),
            );
          },
          childAspectRatio: 175 / 255,
        )
    );
  }
}

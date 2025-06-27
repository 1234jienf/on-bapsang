import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/component/pagination_int_grid_view.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/community/component/community_card.dart';
import 'package:frontend/community/view/community_detail_screen.dart';
import 'package:frontend/mypage/provider/mypage_community_provider.dart';
import 'package:go_router/go_router.dart';

class MypageCommunityScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageCommunityScreen';

  const MypageCommunityScreen({super.key});

  @override
  ConsumerState<MypageCommunityScreen> createState() => _MypageCommunityScreenState();
}

class _MypageCommunityScreenState extends ConsumerState<MypageCommunityScreen> {
  late final CommunityParams _params;

  @override
  void initState() {
    super.initState();
    _params = CommunityParams(keyword: null, sort: 'desc');

    Future.microtask(() {
      ref.read(mypageCommunityProvider(_params));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        title: Text("mypage.community".tr()),
        backgroundColor: Colors.white,
      ),
      child: PaginationIntGridView(
        provider: mypageCommunityProvider(CommunityParams(keyword: null, sort: 'desc')),
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
      ),
    );
  }
}

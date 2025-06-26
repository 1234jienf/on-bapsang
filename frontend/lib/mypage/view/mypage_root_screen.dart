import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/mypage/component/mypage_appbar.dart';
import 'package:frontend/mypage/provider/mypage_provider.dart';
import 'package:frontend/mypage/view/mypage_community_screen.dart';
import 'package:frontend/mypage/view/mypage_fix_info_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_community_screen.dart';
import 'package:frontend/mypage/view/mypage_scrap_recipe_screen.dart';
import 'package:go_router/go_router.dart';

class MypageRootScreen extends ConsumerStatefulWidget {
  static String get routeName => 'MypageRootScreen';

  const MypageRootScreen({super.key});

  @override
  ConsumerState<MypageRootScreen> createState() => _MypageRootScreenState();
}

class _MypageRootScreenState extends ConsumerState<MypageRootScreen> {
  @override
  Widget build(BuildContext context) {
    final mypageAsync = ref.watch(mypageInfoProvider);

    // 컴포넌트 사이 갭
    final double componentGap = 20.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 10.0;

    return mypageAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('$err')),
      data: (info) => DefaultLayout(
        appBar: MypageAppbar(isImply: true, name: info.data.nickname),
        backgroundColor: Colors.white,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: sideGap),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MypageScrapRecipeScreen.routeName,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)
                    )
                  ),
                  child: Text("mypage.scrap_recipe".tr(), style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(height: componentGap,),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MypageCommunityScreen.routeName,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5)
                      )
                  ),
                  child: Text("mypage.community".tr(), style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(height: componentGap,),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MypageScrapCommunityScreen.routeName,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5)
                      )
                  ),
                  child: Text("mypage.scrap_community".tr(), style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(height: componentGap,),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    MypageFixInfoScreen.routeName,
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5)
                      )
                  ),
                  child: Text("mypage.setting_info".tr(), style: TextStyle(fontSize: 17),),
                ),
              ),
              SizedBox(height: componentGap,),
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)
                    )
                ),
                child: Text("mypage.setting_language".tr(), style: TextStyle(fontSize: 17),),
              ),
              SizedBox(height: componentGap,),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Text("mypage.withdraw".tr(), style: TextStyle(fontSize: 17, color: Colors.grey),),
              ),
            ],
          ),
        ),
      )
    );
  }
}

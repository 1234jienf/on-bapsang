import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

import 'package:frontend/mypage/component/mypage_appbar.dart';

class MypageRootScreen extends StatefulWidget {
  static String get routeName => 'MypageRootScreen';

  const MypageRootScreen({super.key});

  @override
  State<MypageRootScreen> createState() => _MypageRootScreenState();
}

// Todo: 각 메뉴 확실하게, 와이어 프레임 나오면 다시 만들기
class _MypageRootScreenState extends State<MypageRootScreen> {
  @override
  Widget build(BuildContext context) {
    // 컴포넌트 사이 갭
    final double componentGap = 20.0;
    // 화면 전체 양 사이드 갭
    final double sideGap = 10.0;

    return DefaultLayout(
      appBar: MypageAppbar(isImply: true),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: sideGap),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80.0,),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5)
                )
              ),
              child: Text('찜한 레시피', style: TextStyle(fontSize: 17),),
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
              child: Text('내가 쓴 글 모아보기', style: TextStyle(fontSize: 17),),
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
              child: Text('스크랩 누른 글', style: TextStyle(fontSize: 17),),
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
              child: Text('언어 설정', style: TextStyle(fontSize: 17),),
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
              child: Text('회원 정보 수정', style: TextStyle(fontSize: 17),),
            ),
            SizedBox(height: componentGap,),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Text('회원 탈퇴', style: TextStyle(fontSize: 17, color: Colors.grey),),
            ),
          ],
        ),
      )
    );
  }
}

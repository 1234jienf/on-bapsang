import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/mypage/model/mypage_userInfo_model.dart';
import 'package:frontend/mypage/repository/mypage_repository.dart';

// 마이페이지 정보 가져오기
final mypageInfoProvider = FutureProvider<MypageResponseModel>((ref) async {
  final repository = ref.watch(mypageRepositoryProvider);
  return await repository.getMypageData();
});


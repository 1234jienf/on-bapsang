import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 추가 필요
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/component/sign_up_app_bar.dart';
import 'package:frontend/signup/view/sign_up_food_prefer_list_screen.dart';
import 'package:frontend/signup/view/sign_up_info_screen.dart';

import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/signup/view/sign_up_taste_dish_prefer_list_screen.dart';
import 'package:frontend/user/provider/user_provider.dart';

// todo: 프로필 이미지....?
class SignUpRootScreen extends ConsumerStatefulWidget { // StatefulWidget → ConsumerStatefulWidget
  static String get routeName => 'SignUpRootScreen';

  const SignUpRootScreen({super.key});

  @override
  ConsumerState<SignUpRootScreen> createState() => _SignUpRootScreenState(); // State → ConsumerState
}

class _SignUpRootScreenState extends ConsumerState<SignUpRootScreen> { // State → ConsumerState
  int currentStep = 1;
  SignupRequest signupData = SignupRequest(
      username: '',
      password: ''
  );

  void nextStep() {
    setState(() {
      if (currentStep < 3) {
        currentStep++;
      }
    });
  }

  void updateStep1Data({
    required String username,
    required String password,
    required String nickname,
    required String country,
    required int age,
    required String location,
  }) {
    setState(() {
      signupData.username = username;
      signupData.password = password;
      signupData.nickname = nickname;
      signupData.country = country;
      signupData.age = age;
      signupData.location = location;
    });
    nextStep();
  }

  void updateStep2Data(List<int> favoriteTasteIds) {
    setState(() {
      signupData.favoriteTasteIds = favoriteTasteIds;
    });
    nextStep();
  }

  void updateStep3Data({
    required List<int> favoriteDishIds,
    required List<int> favoriteIngredientIds,
  }) async { // async 키워드를 메소드에 직접 추가
    setState(() {
      signupData.favoriteDishIds = favoriteDishIds;
      signupData.favoriteIngredientIds = favoriteIngredientIds;
    });

    // 익명 함수 대신 직접 호출
    await ref.read(userProvider.notifier).signup(userInfo: signupData);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: SignUpAppBar(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: currentStep == 1
              ? SignUpInfoScreen(
              onComplete: updateStep1Data,
              initialData: signupData
          )
              : currentStep == 2
              ? SignUpFoodPreferListScreen(
              onComplete: updateStep2Data,
              initialData: signupData
          )
              : SignUpTasteDishPreferListScreen(
              onComplete: updateStep3Data,
              initialData: signupData
          )
      ),
    );
  }
}
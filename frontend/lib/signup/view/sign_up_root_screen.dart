import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/component/sign_up_app_bar.dart';
import 'package:frontend/signup/view/sign_up_food_prefer_list_screen.dart';
import 'package:frontend/signup/view/sign_up_info_screen.dart';

import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/signup/view/sign_up_profile_image_screen.dart';
import 'package:frontend/signup/view/sign_up_taste_dish_prefer_list_screen.dart';
import 'package:frontend/user/provider/user_provider.dart';


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
  bool isLoading = false;

  void nextStep() {
    setState(() {
      if (currentStep < 4) {
        currentStep++;
      }
    });
  }

  void previousStep() {
    setState(() {
      if (currentStep > 1) {
        currentStep--;        // 이전 단계로만 이동
      } else {
        Navigator.of(context).pop(); // 1단계라면 실제 뒤로가기
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
      signupData.favoriteIngredientIds = favoriteTasteIds;
    });
    nextStep();
  }

  void updateStep3Data({
    required List<int> favoriteDishIds,
    required List<int> favoriteIngredientIds,
  }) async {
    setState(() {
      signupData.favoriteDishIds = favoriteDishIds;
      signupData.favoriteTasteIds = favoriteIngredientIds;
    });
    nextStep();
  }

  void updateStep4Data(File profileImage) async {
    setState(() {
      signupData.profileImage = profileImage;
      isLoading = true;
    });

    // 회원가입
    try {
      // print("[요청 아이디]${signupData.username}");
      // print("[요청 비번]${signupData.password}");
      // print("[요청 재료]${signupData.favoriteIngredientIds}");
      // print("[요청 음식]${signupData.favoriteDishIds}");
      // print("[요청 맛]${signupData.favoriteTasteIds}");
      // print("[요청 닉네임]${signupData.nickname}");
      // print("[요청 데이터 사진]${signupData.profileImage}");
      await ref.read(userProvider.notifier).signup(userInfo: signupData);
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('회원가입 실패'),
          content: const Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentStep == 1,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) previousStep();   // pop 못 했으니 단계만 뒤로
      },

      child: Stack(
        children: [
          DefaultLayout(
            appBar: SignUpAppBar(onBack: previousStep),
            resizeToAvoidBottomInset: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: currentStep == 1
                  ? SignUpInfoScreen(
                onComplete: updateStep1Data,
                initialData: signupData,
              )
                  : currentStep == 2
                  ? SignUpFoodPreferListScreen(
                onComplete: updateStep2Data,
                initialData: signupData,
              )
                  : currentStep == 3
                  ? SignUpTasteDishPreferListScreen(
                onComplete: updateStep3Data,
                initialData: signupData,
              )
                  : SignUpProfileImageScreen(
                onComplete: updateStep4Data,
                initialData: signupData,
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
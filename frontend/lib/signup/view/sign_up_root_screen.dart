import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/component/sign_up_app_bar.dart';
import 'package:frontend/signup/view/sign_up_food_prefer_list_screen.dart';
import 'package:frontend/signup/view/sign_up_info_screen.dart';

import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/signup/view/sign_up_profile_image_screen.dart';
import 'package:frontend/signup/view/sign_up_taste_dish_prefer_list_screen.dart';
import 'package:frontend/signup/view/sign_up_terms_of_service_screen.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

class SignUpRootScreen extends ConsumerStatefulWidget {
  static String get routeName => 'SignUpRootScreen';

  const SignUpRootScreen({super.key});

  @override
  ConsumerState<SignUpRootScreen> createState() => _SignUpRootScreenState(); // State → ConsumerState
}

class _SignUpRootScreenState extends ConsumerState<SignUpRootScreen> {
  int currentStep = 0;
  SignupRequest signupData = SignupRequest(username: '', password: '');
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
      if (currentStep > 0) {
        currentStep--; // 이전 단계로만 이동
      } else {
        context.pop(); // 0단계라면 실제 뒤로가기
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

  void updateStep2Data(List<int> favoriteIngredientIds) {
    setState(() {
      signupData.favoriteIngredientIds = favoriteIngredientIds;
    });
    nextStep();
  }

  void updateStep3Data({
    required List<int> favoriteDishIds,
    required List<int> favoriteTasteIds,
  }) async {
    setState(() {
      signupData.favoriteDishIds = favoriteDishIds;
      signupData.favoriteTasteIds = favoriteTasteIds;
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
      await ref.read(userProvider.notifier).signup(userInfo: signupData);
    } catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
          (context) => AlertDialog(
            title: Text(context.tr("signup.signup_fail")),
            content: Text(context.tr("signup.signup_fail_message")),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text(context.tr("signup.ok")),
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
      canPop: currentStep == 0,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) previousStep(); // pop 못 했으니 단계만 뒤로
      },

      child: Stack(
        children: [
          DefaultLayout(
            appBar: SignUpAppBar(onBack: previousStep, step: currentStep),
            resizeToAvoidBottomInset: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child:
                currentStep == 0 ? SignUpTermsOfServiceScreen(onComplete: nextStep,) :
                currentStep == 1
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
              color: Colors.black.withValues(alpha: 0.1),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

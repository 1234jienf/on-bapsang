import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/signup/model/sign_up_language.dart';
import 'package:frontend/signup/provider/sign_up_language_provider.dart';
import 'package:frontend/signup/view/sign_up_terms_of_service.dart';
import 'package:go_router/go_router.dart';

class SignUpTermsOfServiceScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const SignUpTermsOfServiceScreen({super.key, required this.onComplete});

  @override
  ConsumerState<SignUpTermsOfServiceScreen> createState() =>
      _ConsumerSignUpTermsOfServiceScreenState();
}

class _ConsumerSignUpTermsOfServiceScreenState
    extends ConsumerState<SignUpTermsOfServiceScreen> with TickerProviderStateMixin {
  final double iconGap = 7.0;
  final double heightGap = 20.0;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );

    _slideController.forward();

    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    Future.delayed(const Duration(seconds: 1), () {
      _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool isAllSelected = false;
  List<bool> isSelected = [false, false, false, false] ;

  void toggleAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      isSelected = List.filled(4, isAllSelected);
    });
  }

  void toggleItem(int index) {
    setState(() {
      isSelected[index] = !isSelected[index];
      isAllSelected = isSelected.every((e) => e);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allAgreed = isSelected.every((e) => e);
    final lang = ref.watch(signUpLanguageProvider);
    final texts = signUpLanguage[lang]!;


    final terms = [
      {'title': texts['term1'], 'routeExtra': 1},
      {'title': texts['term2'], 'routeExtra': 2},
      {'title': texts['term3'], 'routeExtra': 3},
      {'title': texts['term4'], 'routeExtra': 0},
    ];

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              AnimatedBuilder(animation: _slideAnimation, builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        texts['welcome']!,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 26),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            texts['description']!,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: toggleAll,
                              child: isAllSelected
                                  ? Icon(Icons.check_circle, color: primaryColor)
                                  : Icon(Icons.check_circle_outline, color: gray500),
                            ),
                            const SizedBox(width: 10),
                            Text(texts['agree_all']!,
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: heightGap),
                    const Divider(color: gray500, height: 1),
                    SizedBox(height: heightGap),
                    ...List.generate(terms.length, (index) {
                      final term = terms[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: heightGap),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => toggleItem(index),
                                  child: isSelected[index]
                                      ? Icon(Icons.check_circle, color: primaryColor)
                                      : Icon(Icons.check_circle_outline, color: gray500,),
                                ),
                                SizedBox(width: iconGap),
                                Text(term['title'] as String, style: const TextStyle(fontSize: 16.0)),
                              ],
                            ),
                            term['routeExtra'] != 0 ?
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(SignUpTermsOfService.routeName,
                                    extra: term['routeExtra']);
                              },
                              child: const Icon(Icons.arrow_forward_ios_outlined,
                                  size: 16.0, color: gray700),
                            ) : SizedBox(),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
      
            ],
          ),
      
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: GestureDetector(
                onTap: allAgreed ? widget.onComplete : null,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: allAgreed ? Colors.black : gray400,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      context.tr('common.next'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
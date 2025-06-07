import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/go_router/provider/main_provider.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

import '../../signup/view/sign_up_root_screen.dart';
import '../model/user_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String username = '';
  String password = '';


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);
    return
      DefaultLayout(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (String value) {
                        username = value;
                      },
                      decoration: _customTextFormField('아이디'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: true,
                      onChanged: (String value) {
                        password = value;
                      },
                      decoration: _customTextFormField('비밀번호'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: state is UserModelLoading ? null : () async {
                        ref.read(userProvider.notifier).login(username: username, password: password);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(MediaQuery.of(context).size.width, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      child: Text('로그인'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                '아이디 찾기',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                '비밀번호 찾기',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '|',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.read(mainProvider.notifier).logout();
                                context.pushNamed(SignUpRootScreen.routeName);
                              },
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),],
            ),
          ),
        ),
      );
  }

  InputDecoration _customTextFormField(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 16.0,
        color: Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1.0, color: Colors.grey),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

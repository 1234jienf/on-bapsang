import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontend/common/const/colors.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/user/model/user_model.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:go_router/go_router.dart';

import '../../signup/view/sign_up_root_screen.dart';

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
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(color: primaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset(
              //   'asset/img/app_title.png',
              //   width: 150,
              //   fit: BoxFit.contain
              // ),
              SizedBox(height: 50.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (String value) {
                        setState(() {
                          username = value;
                        });
                      },
                      decoration: _customTextFormField('아이디'),
                      autofocus: true,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: true,
                      onChanged: (String value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: _customTextFormField('비밀번호'),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: (username.isNotEmpty && password.isNotEmpty)
                        ? () async {
                          final result = await ref
                              .read(userProvider.notifier)
                              .login(username: username, password: password);

                          if (result is UserModelError && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                                insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                titlePadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                contentPadding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                                actionsPadding: EdgeInsets.only(right: 4, bottom: 4),

                                title: const Text('로그인 실패'),
                                content: Text(result.message),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text('확인', style: TextStyle(color: Colors.black),),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: Size(
                          MediaQuery.of(context).size.width,
                          60,
                        ),
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
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            context.pushNamed(SignUpRootScreen.routeName);
                          },
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
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

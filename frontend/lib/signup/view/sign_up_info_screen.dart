import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/signup/provider/sign_up_language_provider.dart';
import 'package:frontend/user/provider/user_provider.dart';
import 'package:frontend/user/repository/user_repository.dart';

Locale _localeFromCode(String code) => switch (code.toUpperCase()) {
  'EN' => const Locale('en'),
  'JA' => const Locale('ja'),
  'ZH' => const Locale('zh'),
  'KO' || _ => const Locale('ko'),
};

extension SignUpLanguageX on SignUpLanguage {
  static SignUpLanguage fromCode(String code) => switch (code.toUpperCase()) {
    'EN' => SignUpLanguage.en,
    'JA' => SignUpLanguage.jp,
    'ZH' => SignUpLanguage.zh,
    'KO' || _ => SignUpLanguage.ko,
  };
}



class SignUpInfoScreen extends ConsumerStatefulWidget {
  final Function({
  required String username,
  required String password,
  required String nickname,
  required String country,
  required int age,
  required String location,
  }) onComplete;
  final SignupRequest? initialData;

  const SignUpInfoScreen({
    super.key,
    required this.onComplete,
    this.initialData,
  });

  @override
  ConsumerState<SignUpInfoScreen> createState() => _SignUpInfoScreenState();
}

class _SignUpInfoScreenState extends ConsumerState<SignUpInfoScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  String? selectedCountry;

  String? usernameError;
  String? passwordError;
  String? passwordConfirmError;
  String? nicknameError;
  String? countryError;
  String? usernameCheckMessage;

  bool isCheckingUsername = false;
  bool isUsernameChecked = false;
  bool isUsernameAvailable = false;

  bool _showPassword = false;
  bool _showPasswordConfirm = false;
  String _latestCheckedEmail = '';

  final RegExp _emailRegex = RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      usernameController.text = widget.initialData!.username;
      passwordController.text = widget.initialData!.password;
      passwordConfirmController.text = widget.initialData!.password;
      nicknameController.text = widget.initialData!.nickname ?? '';
      selectedCountry = widget.initialData!.country;
      isUsernameChecked = true;
      isUsernameAvailable = true;
    }

    usernameController.addListener(() {
      if (isUsernameChecked &&
          usernameController.text.trim() != _latestCheckedEmail) {
        setState(() {
          isUsernameChecked = false;
          isUsernameAvailable = false;
          usernameCheckMessage = null;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedCountry = context.locale.languageCode.toUpperCase();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nicknameController.dispose();
    super.dispose();
  }


  String? _emailFormatValidator(String value) {
    if (value.isEmpty) return context.tr('signup.email_hint');
    if (value.length > 99) return context.tr('signup.email_length');
    if (!_emailRegex.hasMatch(value)) return context.tr('signup.email_form');
    return null;
  }

  String? validateUsername(String value) {
    value = value.trim();
    final formatErr = _emailFormatValidator(value);
    if (formatErr != null) return formatErr;
    if (!isUsernameChecked) return context.tr('signup.email_not_validate');
    if (!isUsernameAvailable) return context.tr('signup.email_invalidate');
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return context.tr('signup.password_no');
    if (value.length < 8 || value.length > 30) {
      return context.tr('signup.password_length');
    }

    int count = 0;
    if (RegExp(r'[A-Z]').hasMatch(value)) count++;
    if (RegExp(r'[a-z]').hasMatch(value)) count++;
    if (RegExp(r'\d').hasMatch(value)) count++;
    if (RegExp(r'[@\$!%*?&]').hasMatch(value)) count++;

    if (count < 2) return context.tr('signup.password_form');
    return null;
  }

  String? validatePasswordConfirm(String value) {
    if (value.isEmpty) return context.tr('signup.password_check_no');
    if (value != passwordController.text) {
      return context.tr('signup.password_mismatch');
    }
    return null;
  }

  String? validateNickname(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return context.tr('signup.nickname_no');
    if (trimmed.length < 2 || trimmed.length > 15) {
      return context.tr('signup.nickname_length');
    }
    return null;
  }

  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) return context.tr('signup.language_hint');
    return null;
  }

  Future<void> checkUsername() async {
    final email = usernameController.text.trim();
    final formatError = _emailFormatValidator(email);
    if (formatError != null) {
      setState(() => usernameError = formatError);
      return;
    }

    setState(() => isCheckingUsername = true);
    try {
      final repo = ref.read(userRepositoryProvider);
      final resp = await repo.checkUsername(email);

      setState(() {
        isUsernameChecked = true;
        isUsernameAvailable = !resp.available;
        usernameError = !resp.available ? null : context.tr('signup.email_invalidate');
        usernameCheckMessage = !resp.available ? context.tr('signup.email_ok') : null;
        _latestCheckedEmail = email;
      });
    } catch (_) {
      setState(() {
        usernameError = context.tr('signup.email_error'); // add this key if needed
      });
    } finally {
      setState(() => isCheckingUsername = false);
    }
  }

  bool validateAll() {
    setState(() {
      usernameError = validateUsername(usernameController.text);
      passwordError = validatePassword(passwordController.text);
      passwordConfirmError =
          validatePasswordConfirm(passwordConfirmController.text);
      nicknameError = validateNickname(nicknameController.text);
      countryError = validateCountry(selectedCountry);
    });

    return usernameError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        nicknameError == null &&
        countryError == null;
  }

  void onNextPressed() {
    if (validateAll()) {
      context.setLocale(_localeFromCode(selectedCountry!));

      ref
        .read(signUpLanguageProvider.notifier)
        .changeLanguage(SignUpLanguageX.fromCode(selectedCountry!));

      widget.onComplete(
        username: usernameController.text,
        password: passwordController.text,
        nickname: nicknameController.text,
        country: selectedCountry!,
        age: 30, // 안쓰는거 그냥 고정으로
        location: '한국',
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    ref.listen<String?>(languageProvider, (_, next) {
      if (next != null) {
        setState(() {
          selectedCountry = next.toUpperCase();
        });
      }
    });


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16.0),
                    Text(context.tr('signup.email'),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _emailTextField()),
                        const SizedBox(width: 8),
                        _dupCheckButton(),
                      ],
                    ),
                    if (usernameCheckMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(usernameCheckMessage!,
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12)),
                      ),
                    const SizedBox(height: 30.0),
                    _buildTextField(
                      title: context.tr('signup.password'),
                      hintText: context.tr('signup.password_hint'),
                      controller: passwordController,
                      errorText: passwordError,
                      obscureText: !_showPassword,
                      onChanged: (_) {
                        if (passwordError != null) {
                          setState(() {
                            passwordError =
                                validatePassword(passwordController.text);
                          });
                        }
                      },
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _showPassword = !_showPassword),
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    _buildTextField(
                      title: context.tr('signup.password_check'),
                      hintText: context.tr('signup.password_check_hint'),
                      controller: passwordConfirmController,
                      errorText: passwordConfirmError,
                      obscureText: !_showPasswordConfirm,
                      onChanged: (_) {
                        if (passwordConfirmError != null) {
                          setState(() {
                            passwordConfirmError = validatePasswordConfirm(
                                passwordConfirmController.text);
                          });
                        }
                      },
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _showPasswordConfirm = !_showPasswordConfirm),
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(
                            _showPasswordConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 17,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    _buildTextField(
                      title: context.tr('signup.nickname'),
                      hintText: context.tr('signup.nickname_hint'),
                      controller: nicknameController,
                      errorText: nicknameError,
                      onChanged: (_) {
                        if (nicknameError != null) {
                          setState(() {
                            nicknameError =
                                validateNickname(nicknameController.text);
                          });
                        }
                      },
                    ),
                    Text(context.tr('signup.language'),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    DropdownButtonFormField<String>(
                      value: context.locale.languageCode.toUpperCase(),
                      hint: Text(context.tr('signup.language_hint'),
                          style: const TextStyle(fontSize: 14.0)),
                      items: const [
                        DropdownMenuItem(value: 'KO', child: Text('한국어')),
                        DropdownMenuItem(value: 'EN', child: Text('English')),
                        DropdownMenuItem(value: 'ZH', child: Text('中文')),
                        DropdownMenuItem(value: 'JA', child: Text('日本語')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedCountry = value;
                        });

                        context.setLocale(_localeFromCode(value));

                        ref.read(signUpLanguageProvider.notifier)
                            .changeLanguage(SignUpLanguageX.fromCode(value));
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: countryError != null
                                  ? Colors.red
                                  : Colors.black,
                              width: 1),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: countryError != null
                                  ? Colors.red
                                  : Colors.blue,
                              width: 2),
                        ),
                        errorText: countryError,
                        errorStyle: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: bottomInset > 0 ? bottomInset : 32.0),
              child: GestureDetector(
                onTap: onNextPressed,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
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
      ),
    );
  }


  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    String? errorText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Function(String)? onChanged,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14.0),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: errorText != null ? Colors.red : Colors.black, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: errorText != null ? Colors.red : Colors.blue, width: 2),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12.0),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 32),
          ),
        ),
        const SizedBox(height: 30.0),
      ],
    );
  }

  Widget _emailTextField() {
    return TextField(
      controller: usernameController,
      decoration: InputDecoration(
        hintText: context.tr('signup.email_hint'),
        hintStyle: const TextStyle(fontSize: 14.0),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 5),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: usernameError != null ? Colors.red : Colors.black,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: usernameError != null ? Colors.red : Colors.blue,
            width: 2,
          ),
        ),
        errorText: usernameError,
        errorStyle: const TextStyle(fontSize: 12.0),
      ),
    );
  }

  Widget _dupCheckButton() {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: isCheckingUsername ? null : checkUsername,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: isCheckingUsername
            ? const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Text(context.tr('signup.email_validate'),
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

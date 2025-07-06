import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';
import 'package:frontend/user/repository/user_repository.dart';

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
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? selectedCountry;

  String? usernameError;
  String? passwordError;
  String? passwordConfirmError;
  String? nicknameError;
  String? ageError;
  String? countryError;
  String? usernameCheckMessage;

  bool isCheckingUsername = false;
  bool isUsernameChecked = false;
  bool isUsernameAvailable = false;

  bool _showPassword = false;
  bool _showPasswordConfirm = false;
  String _latestCheckedEmail = '';

  final RegExp _emailRegex = RegExp(
      r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,}$'
  );
  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      usernameController.text = widget.initialData!.username;
      passwordController.text = widget.initialData!.password;
      passwordConfirmController.text = widget.initialData!.password;
      nicknameController.text = widget.initialData!.nickname ?? '';
      locationController.text = widget.initialData!.location ?? '';
      selectedCountry = widget.initialData!.country;
      if (widget.initialData!.age != null) {
        ageController.text = widget.initialData!.age.toString();
      }
      isUsernameChecked = true;
      isUsernameAvailable = true;
    }

    usernameController.addListener(() {
      if (isUsernameChecked && usernameController.text.trim() != _latestCheckedEmail) {
        setState(() {
          isUsernameChecked = false;
          isUsernameAvailable = false;
          usernameCheckMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nicknameController.dispose();
    ageController.dispose();
    locationController.dispose();
    super.dispose();
  }

  String? _emailFormatValidator(String value) {
    if (value.isEmpty) return '이메일을 입력해주세요';
    if (value.length > 99) return '100자 이하로 입력해주세요';

    if (!_emailRegex.hasMatch(value)) return '올바른 이메일 형식이 아닙니다';
    return null;
  }

  String? validateUsername(String value) {
    final formatErr = _emailFormatValidator(value);
    if (formatErr != null) return formatErr;

    if (!isUsernameChecked)   return '이메일 중복검사를 완료해주세요';
    if (!isUsernameAvailable) return '이미 사용 중인 이메일입니다';
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) return '비밀번호를 입력해주세요';
    if (value.length < 8 || value.length > 30) return '8~30자리로 입력해주세요';

    int count = 0;
    if (RegExp(r'[A-Z]').hasMatch(value)) count++;
    if (RegExp(r'[a-z]').hasMatch(value)) count++;
    if (RegExp(r'\d').hasMatch(value)) count++;
    if (RegExp(r'[@\$!%*?&]').hasMatch(value)) count++;

    if (count < 2) return '영문 대소문자, 숫자, 특수문자 중 2가지 이상 조합이어야 합니다';
    return null;
  }

  String? validatePasswordConfirm(String value) {
    if (value.isEmpty) return '비밀번호 확인을 입력해주세요';
    if (value != passwordController.text) return '비밀번호가 일치하지 않습니다';
    return null;
  }

  String? validateNickname(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '닉네임을 입력해주세요';
    if (trimmed.length < 2 || value.length > 15) return '2~15자리로 입력해주세요';
    return null;
  }

  String? validateAge(String value) {
    if (value.isEmpty) return '나이를 입력해주세요';
    final age = int.tryParse(value);
    if (age == null) return '숫자만 입력해주세요';
    if (age < 1 || age > 120) return '올바른 나이를 입력해주세요';
    return null;
  }

  String? validateCountry(String? value) {
    if (value == null || value.isEmpty) return '언어를 선택해주세요';
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
        isUsernameChecked   = true;
        isUsernameAvailable = !resp.available;
        usernameError       = !resp.available ? null : '이미 사용 중인 이메일입니다';
        usernameCheckMessage= !resp.available ? '사용 가능한 이메일입니다' : null;
        _latestCheckedEmail = email;
      });
    } catch (e) {
      setState(() {
        usernameError = '중복검사 중 오류가 발생했습니다';
      });
    } finally {
      setState(() => isCheckingUsername = false);
    }
  }

  bool validateAll() {
    setState(() {
      usernameError = validateUsername(usernameController.text);
      passwordError = validatePassword(passwordController.text);
      passwordConfirmError = validatePasswordConfirm(passwordConfirmController.text);
      nicknameError = validateNickname(nicknameController.text);
      ageError = validateAge(ageController.text);
      countryError = validateCountry(selectedCountry);
    });

    return usernameError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        nicknameError == null &&
        ageError == null &&
        countryError == null;
  }

  void onNextPressed() {
    if (validateAll()) {
      widget.onComplete(
        username: usernameController.text,
        password: passwordController.text,
        nickname: nicknameController.text,
        country: selectedCountry!,
        age: int.parse(ageController.text),
        location: '한국',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0),
                      const Text('이메일', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _emailTextField()),
                          const SizedBox(width: 8),
                          _dupCheckButton(),
                        ],
                      ),
                      if (usernameCheckMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(usernameCheckMessage!, style: const TextStyle(color: Colors.green, fontSize: 12)),
                        ),

                      const SizedBox(height: 30.0),
                      _buildTextField(
                        title: '비밀번호',
                        hintText: '8~30자, 영문/숫자/특수문자 중 2종 이상 필수',
                        controller: passwordController,
                        errorText: passwordError,
                        obscureText: !_showPassword,
                        onChanged: (value) {
                          if (passwordError != null) {
                            setState(() {
                              passwordError = validatePassword(value);
                            });
                          }
                        },
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() {
                            _showPassword = !_showPassword;
                          }),
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              _showPassword ? Icons.visibility_off : Icons.visibility,
                              size: 17,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      ),
                      _buildTextField(
                        title: '비밀번호 확인',
                        hintText: '비밀번호를 다시 입력해주세요',
                        controller: passwordConfirmController,
                        errorText: passwordConfirmError,
                        obscureText: !_showPasswordConfirm,
                        onChanged: (value) {
                          if (passwordConfirmError != null) {
                            setState(() {
                              passwordConfirmError = validatePasswordConfirm(value);
                            });
                          }
                        },
                        suffixIcon: GestureDetector(
                          onTap: () => setState(() {
                            _showPasswordConfirm = !_showPasswordConfirm;
                          }),
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              _showPasswordConfirm ? Icons.visibility_off : Icons.visibility,
                              size: 17,
                              color: Colors.grey[700],
                            ),
                          ),
                        )
                      ),
                      _buildTextField(
                        title: '닉네임',
                        hintText: '2~10자리의 닉네임을 입력해주세요',
                        controller: nicknameController,
                        errorText: nicknameError,
                        onChanged: (value) {
                          if (nicknameError != null) {
                            setState(() {
                              nicknameError = validateNickname(value);
                            });
                          }
                        },
                      ),
                      _buildTextField(
                        title: '나이',
                        hintText: '나이를 숫자로만 입력해주세요',
                        controller: ageController,
                        errorText: ageError,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (ageError != null) {
                            setState(() {
                              ageError = validateAge(value);
                            });
                          }
                        },
                      ),
                      const Text('언어 선택', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      DropdownButtonFormField<String>(
                        value: selectedCountry,
                        hint: const Text('언어를 선택해주세요', style: TextStyle(fontSize: 14.0)),
                        items: const [
                          DropdownMenuItem(value: 'KO', child: Text('한국어')),
                          DropdownMenuItem(value: 'EN', child: Text('English')),
                          DropdownMenuItem(value: 'ZH', child: Text('中文')),
                          DropdownMenuItem(value: 'JA', child: Text('日本語')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value;
                          });
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 5),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: countryError != null ? Colors.red : Colors.black,
                              width: 1,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: countryError != null ? Colors.red : Colors.blue,
                              width: 2,
                            ),
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
                padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 32.0),
                child: GestureDetector(
                  onTap: onNextPressed,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: Text(
                        '다음',
                        style: TextStyle(
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
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.black, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.blue, width: 2),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 12.0),
            suffixIcon: suffixIcon,
            suffixIconConstraints: BoxConstraints(minHeight: 0, minWidth: 32)
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
        hintText: '이메일을 입력해주세요',
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
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('중복검사', style: TextStyle(color: Colors.white)),
      ),
    );
  }

}

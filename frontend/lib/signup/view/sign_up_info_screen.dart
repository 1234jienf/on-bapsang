import 'package:flutter/material.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

class SignUpInfoScreen extends StatefulWidget {
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
  State<SignUpInfoScreen> createState() => _SignUpInfoScreenState();
}

class _SignUpInfoScreenState extends State<SignUpInfoScreen> {
  // 각 입력창별 컨트롤러
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // 에러 메시지 상태
  String? usernameError;
  String? passwordError;
  String? passwordConfirmError;
  String? nicknameError;
  String? ageError;
  String? locationError;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      usernameController.text = widget.initialData!.username ?? '';
      passwordController.text = widget.initialData!.password ?? '';
      nicknameController.text = widget.initialData!.nickname ?? '';
      locationController.text = widget.initialData!.location ?? '';
      if (widget.initialData!.age != null) {
        ageController.text = widget.initialData!.age.toString();
      }
    }
  }

  @override
  void dispose() {
    // 메모리 누수 방지
    usernameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    nicknameController.dispose();
    ageController.dispose();
    locationController.dispose();
    super.dispose();
  }

  // 유효성 검사 함수들
  String? validateUsername(String value) {
    if (value.isEmpty || value == '') return '이메일을 입력해주세요';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty || value == '') return '비밀번호를 입력해주세요';
    if (value.length < 8 || value.length > 30) return '8~30자리로 입력해주세요';

    int count = 0;

    if (RegExp(r'[A-Z]').hasMatch(value)) count++; // 대문자
    if (RegExp(r'[a-z]').hasMatch(value)) count++; // 소문자
    if (RegExp(r'\d').hasMatch(value)) count++;    // 숫자
    if (RegExp(r'[@$!%*?&]').hasMatch(value)) count++; // 특수문자

    if (count < 2) return '영문 대소문자, 숫자, 특수문자 중 2가지 이상 조합이어야 합니다';

    return null;
  }

  String? validatePasswordConfirm(String value) {
    if (value.isEmpty) return '비밀번호 확인을 입력해주세요';
    if (value != passwordController.text) return '비밀번호가 일치하지 않습니다';
    return null;
  }

  String? validateNickname(String value) {
    if (value.isEmpty) return '닉네임을 입력해주세요';
    if (value.length < 2 || value.length > 10) return '2~10자리로 입력해주세요';
    return null;
  }

  String? validateAge(String value) {
    if (value.isEmpty) return '나이를 입력해주세요';
    final age = int.tryParse(value);
    if (age == null) return '숫자만 입력해주세요';
    if (age < 1 || age > 100) return '올바른 나이를 입력해주세요';
    return null;
  }

  // 전체 유효성 검사
  bool validateAll() {
    setState(() {
      usernameError = validateUsername(usernameController.text);
      passwordError = validatePassword(passwordController.text);
      passwordConfirmError = validatePasswordConfirm(passwordConfirmController.text);
      nicknameError = validateNickname(nicknameController.text);
      ageError = validateAge(ageController.text);
    });

    return usernameError == null &&
        passwordError == null &&
        passwordConfirmError == null &&
        nicknameError == null &&
        ageError == null;
  }

  // 다음 버튼 클릭 시
  void onNextPressed() {
    if (validateAll()) {
      widget.onComplete(
        username: usernameController.text,
        password: passwordController.text,
        nickname: nicknameController.text,
        country: '한국', // 임시로 하드코딩
        age: int.parse(ageController.text),
        // location: locationController.text,
        location: '한국' // 임시22 여기 어떻게 할건지?
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),

        // 이메일
        _buildTextField(
          title: '이메일',
          hintText: '이메일을 입력해주세요',
          controller: usernameController,
          errorText: usernameError,
          onChanged: (value) {
            if (usernameError != null) {
              setState(() {
                usernameError = validateUsername(value);
              });
            }
          },
        ),

        // 비밀번호
        _buildTextField(
          title: '비밀번호',
          hintText: '8~30자, 영문/숫자/특수문자 중 2종 이상 필수',
          controller: passwordController,
          errorText: passwordError,
          obscureText: true,
          onChanged: (value) {
            if (passwordError != null) {
              setState(() {
                passwordError = validatePassword(value);
              });
            }
          },
        ),

        // 비밀번호 확인
        _buildTextField(
          title: '비밀번호 확인',
          hintText: '비밀번호를 다시 입력해주세요',
          controller: passwordConfirmController,
          errorText: passwordConfirmError,
          obscureText: true,
          onChanged: (value) {
            if (passwordConfirmError != null) {
              setState(() {
                passwordConfirmError = validatePasswordConfirm(value);
              });
            }
          },
        ),

        // 닉네임
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

        // 나이
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

        Expanded(child: SizedBox()),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: GestureDetector(
            onTap: onNextPressed,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black
              ),
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: Center(
                  child: Text(
                      '다음',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0
                      )
                  )
              ),
            ),
          ),
        )
      ],
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 14.0),
              contentPadding: EdgeInsets.only(top: 10, bottom: 5),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: errorText != null ? Colors.red : Colors.black,
                    width: 1
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: errorText != null ? Colors.red : Colors.blue,
                    width: 2
                ),
              ),
              errorText: errorText,
              errorStyle: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
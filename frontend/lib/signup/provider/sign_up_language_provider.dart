import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SignUpLanguage { ko, en, zh, jp }

final signUpLanguageProvider =
StateNotifierProvider<SignUpLanguageNotifier, SignUpLanguage>(
      (ref) => SignUpLanguageNotifier(),
);

class SignUpLanguageNotifier extends StateNotifier<SignUpLanguage> {
  SignUpLanguageNotifier() : super(SignUpLanguage.ko);

  void changeLanguage(SignUpLanguage lang) {
    state = lang;
  }
}
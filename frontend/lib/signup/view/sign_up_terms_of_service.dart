import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/signup/provider/sign_up_language_provider.dart';

import '../model/sign_up_terms_path.dart';

class SignUpTermsOfService extends ConsumerStatefulWidget {
  static String get routeName => 'SignUpTermsOfService';
  final int number;

  const SignUpTermsOfService({super.key, required this.number});

  @override
  ConsumerState<SignUpTermsOfService> createState() => _ConsumerSignUpTermsOfServiceState();
}

class _ConsumerSignUpTermsOfServiceState extends ConsumerState<SignUpTermsOfService> {
  String termsContent = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lang = ref.read(signUpLanguageProvider);
      final path = signUpTermsPath[lang]?[widget.number];
      if(path != null) loadTermsOfService(path);
    });
  }

  Future<void> loadTermsOfService(String endpoint) async {
    final String content = await rootBundle.loadString(
      endpoint,
    );
    setState(() {
      termsContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(signUpLanguageProvider);
    final title = termsTitles[lang]?[widget.number] ?? '';

    return DefaultLayout(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      child: SafeArea(child: Markdown(data: termsContent)),
    );
  }
}

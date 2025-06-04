import 'package:flutter/material.dart';

import '../../../signup/component/sign_up_next_bar.dart';

class SearchDetailVarietyScreen extends StatelessWidget {
  const SearchDetailVarietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [SignUpNextBar(title: '다음', routeName: '',)],);
  }
}

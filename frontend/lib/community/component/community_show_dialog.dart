import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/community_provider.dart';

Future<void> communityShowDialog(BuildContext context, WidgetRef ref, bool isNavigate, String title) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(Duration(milliseconds: 800), () {
        if (context.mounted) {
          context.pop();
        }
      });
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ],
        ),
      );
    },
  );

  if (isNavigate && context.mounted) {
    ref.read(communityProvider);
    context.go('/community');
  }
}

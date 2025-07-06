import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> componentAlertDialog({
  required BuildContext context,
  required String title,
  Duration duration = const Duration(milliseconds: 1000),
}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      Timer(duration, () {
        if (context.mounted) {
          context.pop();
        }
      });

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
      );
    },
  );
}
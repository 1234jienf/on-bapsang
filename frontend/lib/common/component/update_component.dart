import 'package:flutter/material.dart';
import 'dart:async';

Future<void> updateComponent(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      Timer(const Duration(milliseconds: 1000), () {
        if (dialogContext.mounted) {
          Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
        }
      });

      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.update_outlined,
                color: Colors.green,
                size: 48,
              ),
              const SizedBox(height: 20),
              const Text(
                '업데이트 예정입니다',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}
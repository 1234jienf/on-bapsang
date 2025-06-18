import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future communityShowFailDialog(BuildContext context, bool isNavigate) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          if (context.mounted) context.pop();
          if (isNavigate) {
            if (context.mounted) context.go('/community');
          }
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "작성에 실패하였습니다.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
            ],
          ),
        );
      }
  );
}
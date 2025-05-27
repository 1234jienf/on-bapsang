import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:intl/intl.dart';

class CommunityDetailScreen extends StatelessWidget {
  final String id;

  static String get routeName => 'CommunityDetailScreen';

  const CommunityDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '게시물',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      child: _content(),
    );
  }

  Widget _content() {
    final DateTime dt = DateTime.now();
    final String formattedDate = DateFormat('yy년 M월 d일').format(dt);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.account_circle_outlined, size: 32),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('user_0287', style: TextStyle(fontSize: 14)),
                  Text(formattedDate, style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
        Image.asset('asset/img/community_detail_pic.png', fit: BoxFit.cover),
      ],
    );
  }
}

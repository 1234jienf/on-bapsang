import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';

class HomeAlarmScreen extends StatefulWidget {
  static String get routeName => 'HomeAlarmScreen';
  const HomeAlarmScreen({super.key});

  @override
  State<HomeAlarmScreen> createState() => _HomeAlarmScreenState();
}

class _HomeAlarmScreenState extends State<HomeAlarmScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('알림페이지')
        ),
        child: Text('알람')
    );
  }
}

import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final PreferredSizeWidget? renderAppBar;
  final Widget? bottomNavigationBar;


  const DefaultLayout(
      {super.key, required this.child, this.backgroundColor, this.renderAppBar, this.bottomNavigationBar});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      bottomNavigationBar: bottomNavigationBar,
      body: child,
      appBar: renderAppBar,
    );
  }

}

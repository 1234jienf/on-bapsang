import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NextBar extends StatelessWidget {
  final String title;
  final String routeName;
  const NextBar({super.key, required this.title, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {context.pushNamed(routeName);},
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.black,),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

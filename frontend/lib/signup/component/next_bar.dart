import 'package:flutter/material.dart';

class NextBar extends StatelessWidget {
  final String title;
  const NextBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.black,
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

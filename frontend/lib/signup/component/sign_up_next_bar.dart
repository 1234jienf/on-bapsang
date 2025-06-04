import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


class SignUpNextBar extends ConsumerStatefulWidget {
  final String title;
  final String routeName;

  const SignUpNextBar({
    super.key,
    required this.title,
    required this.routeName,

  });

  @override
  ConsumerState<SignUpNextBar> createState() => _SignUpNextBarState();
}

class _SignUpNextBarState extends ConsumerState<SignUpNextBar> {

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        context.pushNamed(widget.routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.black,
        ),
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              widget.title,
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

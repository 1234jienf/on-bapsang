import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SearchBottomFilter extends StatelessWidget {
  const SearchBottomFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Text("search.latest".tr(), style: TextStyle(fontSize: 13.0)),
                Icon(Icons.swap_vert_outlined, size: 20,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

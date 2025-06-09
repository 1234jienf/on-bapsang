import 'package:flutter/material.dart';

class CommunityComment extends StatelessWidget {
  const CommunityComment({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: 3,
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 38,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.account_circle_outlined, size: 32)],
                  ),
                ),

                const SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('user_0287', style: TextStyle(fontSize: 14)),
                    Text(
                      "1234",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: Text(
                            "댓글 영역입니다. 댓글 영역입니다. 댓글 영역입니다.",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      // 하트 아이콘
                      Icon(Icons.favorite_border_outlined, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SeasonalRecipe extends StatelessWidget {
  final int count;

  const SeasonalRecipe({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 175,
                      height: 100,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      '메뉴명',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '9900원, 30분, 초보',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '스크랩 수 $count',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}

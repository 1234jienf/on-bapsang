import 'package:flutter/material.dart';

class SearchRecipeCard extends StatelessWidget {
  const SearchRecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: Row(
        children: [
          Image.asset(
            'asset/img/main_commu.png',
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 6.0),
            child: SizedBox(
              width: 150.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    '간단하게 만드는 밥도둑, 팽이버섯두부조림',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Text('7000원', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 8.0),
                      Text('30분', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 8.0),
                      Text('초보', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Image.asset('asset/img/kid_star.png'),
                      const SizedBox(width: 6.0),
                      Text('4.5', style: TextStyle(fontSize: 12.0)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Icon(Icons.bookmark_border_outlined, size: 22.0,),
        ],
      ),
    );
  }
}

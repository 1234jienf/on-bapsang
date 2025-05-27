import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String userName;

  const CommunityCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return _renderComponent();
  }

  Widget _renderComponent() {
    return SizedBox(
      width: 175,
      height: 260,
      child: Column(
        children: [
          Image.asset(
            'asset/img/search_recipe.png',
            width: 175,
            height: 175,
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.account_circle_outlined, size: 20),
                        const SizedBox(width: 5.0),
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.favorite_border_outlined, size: 20),
                ],
              ),
              const SizedBox(height: 6.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Title 영역입니다',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2,),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '비건 레시피 만들어봤읍니다. 어쩌고 저쩌고 맛있었읍니다. 어쩌고 저쩌고 맛잇었읍니다.',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

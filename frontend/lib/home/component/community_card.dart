import 'package:flutter/material.dart';

class CommunityCard extends StatelessWidget {
  final String userName;
  const CommunityCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return _renderComponent();
  }

  Column _renderComponent() {
    return Column(
      children: List.generate(3, (index) {
        return InkWell(
          onTap: () {},
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(2, (_) {
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(8.0)),
                          width: 175.0,
                          height: 175.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [Icon(Icons.account_circle_outlined),
                                      const SizedBox(width: 5.0,),
                                      Text(
                                        userName,
                                        style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),],
                                  ),
                                  Icon(Icons.favorite_border_outlined),
                                ],
                              ),
                              const SizedBox(height: 8.0,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '비건 레시피 만들어봤읍니다. 어쩌고 저쩌고 맛있었읍니다. 어쩌고 저쩌고 맛잇었읍니다.',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 13.0),
            ],
          ),
        );
      }),
    );
  }
}

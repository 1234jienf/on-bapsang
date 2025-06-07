import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String id;
  static String get routeName => 'RecipeDetailScreen';
  const RecipeDetailScreen({super.key, required this.id});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void listener() {}

  @override
  Widget build(BuildContext context) {
    // 사진, 텍스트 사이 갭
    final double titleTextGap = 10.0;
    // 컴포넌트 사이 갭
    final double componentGap = 20.0;

    // 임시용
    final instructions = [ "우거지와 감자를 깨끗이 씻어 적당한 크기로 썰어 준비합니다.", "돼지뼈를 끓는 물에 담가 핏물을 제거한 후, 새로운 물에 넣고 한 시간 가량 불순물을 제거하며 삶습니다.", "삶은 돼지뼈를 건져내고, 같은 냄비에 양파, 대파, 마늘, 생강 등을 넣고 볶아 향을 냅니다.", "향이 나면 준비한 우거지, 감자, 토마토, 고추장, 된장, 간장, 소금 등을 넣고 물을 부어 끓입니다.", "끓어오르면 약한 불로 줄이고, 한 시간 가량 더 끓여 향과 맛을 우려냅니다.", "마지막으로 다진 파와 후추를 넣어 간을 맞추고, 불을 끕니다.", "완성된 우거지감자탕을 그릇에 담아, 기호에 따라 통깨를 뿌려 내어줍니다." ];

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: CustomScrollView(
          controller: controller,
          slivers: [
            // 레시피 이미지
            SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 402,
                child: Image.network(
                  'https://recipe1.ezmember.co.kr/cache/recipe/2024/01/01/fdf645182aa988e49cb5d525c3c16d791.jpg',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.error, size: 50),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: componentGap),
                  // 레시피 제목
                  Text(
                    '우거지감자탕',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: componentGap),

                  // 레시피 설명(review, descriptions?)
                  Text(
                    '까다로운 남편의 입맛을 맞추기위해 여러번 시도끝에 만들어낸 최적의 레시피입니다. 한번 만들어먹어보시면 사먹는게 아까워요ㅠㅠ',
                    style: TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                  SizedBox(height: componentGap),

                  // 레시피 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      infoWidget(title: '분량', content: '4인분'),
                      infoWidget(title: '시간', content: '2시간이내'),
                      infoWidget(title: '난이도', content: '중급'),
                    ],
                  ),
                  SizedBox(height: componentGap),
                ]),
              ),
            ),

            // 구분선
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(color: Colors.black12),
              ),
            ),

            // 재료
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: componentGap),
                  Text(
                    '재료',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: titleTextGap),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      gradientWidget(name: '청양고추', quantity: '2 개'),
                      Container(height: 1.0, decoration: BoxDecoration(color: Colors.black12),),
                      gradientWidget(name: '감자', quantity: '1 개'),
                      Container(height: 1.0, decoration: BoxDecoration(color: Colors.black12),),
                      gradientWidget(name: '감자', quantity: '1 개'),
                      Container(height: 1.0, decoration: BoxDecoration(color: Colors.black12),),
                      gradientWidget(name: '감자', quantity: '1 개'),
                      Container(height: 1.0, decoration: BoxDecoration(color: Colors.black12),),
                      gradientWidget(name: '감자', quantity: '1 개'),
                    ],
                  ),
                  SizedBox(height: componentGap),
                ]),
              ),
            ),

            // 구분선
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(color: Colors.black12),
              ),
            ),

            // 조리순서
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: componentGap),
                  Text(
                    '조리순서',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: componentGap),
                  ...List.generate(instructions.length, (index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 60.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 15.0),
                              Expanded(
                                child: Text(
                                  instructions[index],
                                  style: TextStyle(
                                    fontSize: 14
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  })
                ]),
              ),
            ),

            // 구분선 3
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                height: 5,
                decoration: BoxDecoration(color: Colors.black12),
              ),
            ),

            // 후기
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: componentGap),
                  Text(
                    '레시피 후기',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: componentGap),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (_) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Flexible(child: Container(height: 100.0, decoration: BoxDecoration(color: Colors.grey))),
                              SizedBox(width: 15.0),
                              Flexible(child: Container(height: 100.0, decoration: BoxDecoration(color: Colors.grey))),
                              SizedBox(width: 15.0),
                              Flexible(child: Container(height: 100.0, decoration: BoxDecoration(color: Colors.grey))),
                            ],
                          ),
                          SizedBox(height: 15.0),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: titleTextGap),
                  InkWell(
                    onTap: (){},
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 1.0)),
                      child: Center(child: Text('더보기')),
                    ),
                  ),
                  SizedBox(height: componentGap),
                ]),
              ),
            ),
          ],
        ),
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10.0),
          child: ElevatedButton(
            onPressed: (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '재료 구매하기/재료보기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        )
      ],
    );
  }
}


Widget infoWidget({
  required String title,
  required String content
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 16, color: Colors.black45),
      ),
      SizedBox(width: 12.0,),
      Text(
        content,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      SizedBox(width: 20.0,)
    ],
  );
}

Widget gradientWidget({
  required String name,
  required String quantity
}) {
  return SizedBox(
    height: 60.0,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          quantity,
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
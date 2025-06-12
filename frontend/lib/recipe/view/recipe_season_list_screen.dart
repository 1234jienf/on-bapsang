import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/recipe/model/recipe_season_ingredient_model.dart';
import 'package:frontend/recipe/component/recipe_season_ingredient_card.dart';

class RecipeSeasonListScreen extends StatefulWidget {
  static String get routeName => 'RecipeSeasonListScreen';

  const RecipeSeasonListScreen({super.key});

  @override
  State<RecipeSeasonListScreen> createState() => _RecipeSeasonListScreenState();
}

class _RecipeSeasonListScreenState extends State<RecipeSeasonListScreen> {
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
    // 임시 데이터
    String jsonData = '''[
    {
      "idntfcNo": 219848,
      "prdlstNm": "완두콩",
      "effect": "-위장기관을 보호하고 습관성 설사나 더부룩한 속을 편하게 해주는데 도움을 줌-대장을 건강하게 해주고 동맥경화증을 예방-장내의 발암물질을 억제시켜 유방암, 전립선암 예방에도 도움-여성 호르몬과 유사한 이소플라본이 풍부하여 골다공증 감소, 콜레스테롤 수치 개선-식이섬유가 장의 활동을 원활하게 해 변비 예방에 도움",
      "purchaseMth": "완두콩은 꼬투리를 보았을 때 짙은 녹색을 띠는 것이 좋은 것입니다. 또한 꼬투리가 마르지 않고 신선한 것이 좋은 것입니다. 안을 열어보았을 때 낟알이 고르고 동글동글하면서 역시 진한 녹색인 것을 고르도록 하세요. 벌레가 먹거나 상처가 난 것은 없는지 확인하는 것이 좋으며, 물러진 완두콩은 상하기 쉽기 때문에 되도록 탄력 있는 콩을 고르는 것이 좋습니다.",
      "cookMth": "완두콩의 품종은 먹는 방법에 따라 나뉘는데요. 꼬투리째 먹을 수 있는 것은 연협종이고, 안의 콩만 먹을 수 있는 것은 경협종, 그리고 꼬투리와 콩 두 개를 모두 먹을 수 있는 것을 겸용종으로 구분합니다. 다 여물지 않은 완두콩을 꼬투리째 익혀 먹을 때는 소금을 넣은 끓는 물에 살짝 데치면 깔끔하면서도 아삭한 맛이 납니다. 밥을 지을 때도 넣어 먹고 스프나 죽으로 갈아서 먹어도 좋습니다. 성숙하기 이전의 푸른 완두는 통조림에 이용하기도 하고, 말려서 먹는 방법도 있답니다. 다만 완두콩에는 미량의 독소가 들어있기 때문에 하루에 40g 이상은 섭취하지 않는 것이 좋습니다.",
      "imgUrl": "https://www.foodnuri.go.kr/cmmn/file/getImage.do?atchFileId=MWCS_000000000000039&fileSn=1",
      "mdistctns": "4월"
    },
    {
      "idntfcNo": 219934,
      "prdlstNm": "마늘",
      "effect": "-마늘의 대표적인 알리신이 식중독균을 죽이고 위궤양을 유발하는  헬리코박터 파이로리균까지 죽이는 효과가 있음-소화를 돕고 면역력도 높이며, 콜레스테롤 수치를 낮춰줌-정력이나 원기를 보하는 강장제 효과가 있음-생마늘을 먹으면 위가 쓰림을 느끼는 것은 마늘이 위 점막을 자극해 위 점막의 기능을 강화 시키는 것",
      "purchaseMth": "겉껍질이 단단하고 무게감이 있으며 하얗게 부풀어 있는 것이 좋습니다. 쪽수가 적고 짜임새가 알차 보이는 것을 고르고 싹이 돋거나 썩은 부분이 있으면 구매하지 않은 것이 좋습니다. 또한 마늘쪽이 너무 크지 않고 마늘 대에서 마늘이 너무 벌어지지 않은 것이 조금 덜 맵고 덜 아립니다. 저렴하게 구입하려면 6월 중순 이후 망마늘로 직거래 구입하는 게 좋습니다.",
      "cookMth": "마늘은 물에 불려놓으면 껍질을 벗기기 쉽습니다. 망에 넣어서 10-15도의 서늘한 곳에 보관합니다. 보관 기한은 1개월이 적당합니다. 마늘을 까고 나서 손가락 끝에 밴 냄새는 식초 몇 방울을 떨어뜨린 후 씻으면 말끔히 없어집니다. 보통 한국음식엔 다진 만들이 많이 들어가, 마늘을 미리 까서 갈은 후 냉장 혹은 냉동 보관하면 요리할 때 보다 쉽게 꺼내 사용 할 수 있습니다.",
      "imgUrl": "https://www.foodnuri.go.kr/cmmn/file/getImage.do?atchFileId=MWCS_000000000000125&fileSn=1",
      "mdistctns": "4월"
    },
    {
      "idntfcNo": 219954,
      "prdlstNm": "파인애플",
      "effect": "-섬유소질이 풍부하고 단맛이 풍부함에도 칼로리가 다른 과일에 비해 높지 않아 다이어트 시 좋음-비염 증상 완화 등 호흡기 질환에 도움이 됨-망간이 다량 들어있어 골격의 형성 및 치아건강에 효과적-통증을 경감시켜주는데 도움이 되어 두통에 효과적",
      "purchaseMth": "잎이 작고 단단한 것이 좋습니다. 껍질색의 1/3정도가 녹색에서 노란색으로 바뀐 것이 좋습니다. 잘라 봤을 때 달콤한 향이 강할수록 당도가 높습니다. 파인애플은 후숙해야 더 맛있는데 설익으면 초록색, 익으면 노란색에 가까운 주황색입니다. 완전히 초록색인 것을 구매하여 서늘하고 햇빛이 들지 않는 곳에서 일주일정도 후숙시킨 후 먹는 것도 좋은 방법입니다.",
      "cookMth": "껍질을 잘라 생과로 주로 먹으며 파인애플 식초, 샐러드 드레싱 등으로 가공되어 섭취하기도 합니다. 고기를 재워둘 때 사용되는데 그 이유는 파인애플에 함유되어 있는 브로멜린이라는 분해효소가 고기를 연하게 만들기 때문입니다. 또한 돼지고기의 단백질과 비타민B1에 파인애플의 비타민C가 더해지면 영양의 균형을 적절히 이루기 때문에 고기와 궁합이 매우 잘 맞는 음식으로 볼 수 있습니다.",
      "imgUrl": "https://www.foodnuri.go.kr/cmmn/file/getImage.do?atchFileId=MWCS_000000000000145&fileSn=1",
      "mdistctns": "4월"
    },
    {
      "idntfcNo": 227363,
      "prdlstNm": "노각",
      "effect": "식이 섬유소가 많아 포만감이 들어 다이어트에 효과적 - 칼륨이 풍부해 체내 노페물 배출 - 염분 배출해 혈압 낮추는 데 도움 ",
      "purchaseMth": "묵직하고 단단한 것이 물이 많아 속이 꽉찬 것입니다. 전체적으로 노란빛이 균일한 것이 좋으며 부분적으로 푸른빛을 띤 것이 아삭아삭하고 맛있습니다. ",
      "cookMth": "무침, 볶음, 절임으로도 활용 가능합니다. ",
      "imgUrl": "https://www.foodnuri.go.kr/cmmn/file/getImage.do?atchFileId=FILE_000000000008230&fileSn=1",
      "mdistctns": "4월"
    },
    {
      "idntfcNo": 227366,
      "prdlstNm": "산마늘",
      "effect": "알리신으로 비타민B1을 활성화시키고 향균작용을 함 - 콜레스테롤을 낮춰주고 비타민A가 피부를 매끄럽게 해줌 - 감기에 대한 저장력을 높이며 호흡기를 튼튼하게 하고 시력을 보호함",
      "purchaseMth": "잎에 수분감이 있고 짙은 녹색이 된것을 고릅니다. ",
      "cookMth": " 장아찌, 쌈, 무침, 샐러드로 조리 가능합니다. ",
      "imgUrl": "https://www.foodnuri.go.kr/cmmn/file/getImage.do?atchFileId=FILE_000000000008233&fileSn=1",
      "mdistctns": "4월"
    }
  ]''';
    List<dynamic> jsonList = json.decode(jsonData);
    final seasonIngredients = jsonList.map((item) => RecipeSeasonIngredientModel.fromJson(item)).toList();

    return DefaultLayout(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          '제철 레시피',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      backgroundColor: Colors.white,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 15.0),
                      RecipeSeasonIngredientCard(
                        seasonIngredientInfo: seasonIngredients[index],
                      ),
                    ],
                  );
                },
                childCount: seasonIngredients.length,
              ),
            )
          )
        ],
      )
    );
  }
}

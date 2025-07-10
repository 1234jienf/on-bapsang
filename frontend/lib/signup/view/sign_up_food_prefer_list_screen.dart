import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

class SignUpFoodPreferListScreen extends StatefulWidget {

  final Function(List<int> favoriteTasteIds) onComplete;
  final SignupRequest? initialData;

  const SignUpFoodPreferListScreen({
    super.key,
    required this.onComplete,
    required this.initialData
  });

  @override
  State<SignUpFoodPreferListScreen> createState() => _SignUpFoodPreferListScreenState();
}

class _SignUpFoodPreferListScreenState extends State<SignUpFoodPreferListScreen> {
  final List<String> options = [
    'common.ingredients.pork',
    'common.ingredients.chicken',
    'common.ingredients.beef',
    'common.ingredients.tomato',
    'common.ingredients.onion',
    'common.ingredients.cucumber',
    'common.ingredients.cabbage',
    'common.ingredients.carrot',
    'common.ingredients.eggplant',
    'common.ingredients.chili_pepper',
    'common.ingredients.lettuce',
    'common.ingredients.potato',
    'common.ingredients.spinach',
  ];

  List<int> selectedIndexes = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    final calculatedIndex = widget.initialData?.favoriteIngredientIds.map((i) => i - 1);
    selectedIndexes = List<int>.from(calculatedIndex ?? []);
  }

  // 다음 버튼 클릭 시
  void onNextPressed() {
    setState(() {
      if (selectedIndexes.isNotEmpty) {
        isError = false;
        widget.onComplete(List<int>.from(selectedIndexes.map((i) => i + 1)));
      } else {
        isError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr("common.favoriteIngredient"),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 15.0),
                    Wrap(
                      children: options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        final isSelected = selectedIndexes.contains(index);
                        return Padding(
                          padding: const EdgeInsets.only(right: 7.0, bottom: 2.0),
                          child: ChoiceChip(
                            label: Text(
                              context.tr(label),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedIndexes.add(index);
                                } else {
                                  selectedIndexes.remove(index);
                                }
                              });
                            },
                            selectedColor: primaryColor,
                            backgroundColor: Colors.white,
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color:
                              isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      context.tr("mypage.selectAtLeastOne"),
                      style: TextStyle(
                        color: isError ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: bottomInset > 0 ? bottomInset : 32.0,
                top: 8.0,
              ),
              child: GestureDetector(
                onTap: onNextPressed,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      context.tr("common.next"),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

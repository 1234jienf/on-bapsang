import 'package:flutter/material.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

class SignUpTasteDishPreferListScreen extends StatefulWidget {
  final Function({
  required List<int> favoriteDishIds,
  required List<int> favoriteIngredientIds,
  }) onComplete;
  final SignupRequest? initialData;

  const SignUpTasteDishPreferListScreen({
    super.key,
    required this.onComplete,
    required this.initialData,
  });

  @override
  State<SignUpTasteDishPreferListScreen> createState() =>
      _SignUpTasteDishPreferListScreenState();
}

class _SignUpTasteDishPreferListScreenState
    extends State<SignUpTasteDishPreferListScreen> {
  final List<String> dishOptions = [
    '김치찌개',
    '된장찌개',
    '비빔밥',
    '불고기',
    '갈비',
    '삼계탕',
    '잡채',
    '김밥',
    '갈비탕',
    '칼국수'
  ];
  final List<String> tasteOptions = ['매운맛', '짠맛', '단맛', '쓴맛', '신맛', '감칠맛'];

  List<int> selectedDishes = [];
  List<int> selectedTastes = [];

  @override
  void initState() {
    super.initState();
    selectedDishes = List<int>.from(widget.initialData?.favoriteDishIds ?? []);
    selectedTastes = List<int>.from(widget.initialData?.favoriteIngredientIds ?? []);
  }

  void onSkipPressed() {
    widget.onComplete(
      favoriteDishIds: [],
      favoriteIngredientIds: [],
    );
  }

  void onNextPressed() {
    widget.onComplete(
      favoriteDishIds: selectedDishes.map((index) => index + 1).toList(),
      favoriteIngredientIds: selectedTastes.map((index) => index + 1).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '맛의 선호',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15.0),
                      Wrap(
                        spacing: 7.0,
                        runSpacing: 2.0,
                        children: tasteOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final label = entry.value;
                          final isSelected = selectedTastes.contains(index);
                          return ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedTastes.add(index);
                                } else {
                                  selectedTastes.remove(index);
                                }
                              });
                            },
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.white,
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color:
                              isSelected ? Colors.white : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30.0),
                      const Text(
                        '좋아하는 한식',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15.0),
                      Wrap(
                        spacing: 7.0,
                        runSpacing: 2.0,
                        children: dishOptions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final label = entry.value;
                          final isSelected = selectedDishes.contains(index);
                          return ChoiceChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedDishes.add(index);
                                } else {
                                  selectedDishes.remove(index);
                                }
                              });
                            },
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.white,
                            showCheckmark: false,
                            labelStyle: TextStyle(
                              color:
                              isSelected ? Colors.white : Colors.black,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: onSkipPressed,
                    child: const Center(
                      child: Text(
                        '건너뛰기',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: onNextPressed,
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Center(
                        child: Text(
                          '다음',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: bottomInset > 0 ? bottomInset : 32.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

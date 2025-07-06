import 'package:flutter/material.dart';
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
   '돼지고기', '닭고기', '소고기',
    '토마토', '양파', '오이', '양배추', '당근', '가지', '고추', '상추', '감자', '시금치'
  ];

  List<int> selectedIndexes = [];
  bool isError = false;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List<int>.from(widget.initialData?.favoriteTasteIds ?? []);
  }

  // 다음 버튼 클릭 시
  void onNextPressed() {
    setState(() {
      if (selectedIndexes.isNotEmpty) {
        isError = false;
        // final updatedIndexes = selectedIndexes.map((index) => index + 1).toList();
        // widget.onComplete(updatedIndexes);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '음식 선호',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 15.0),
                      Wrap(
                        spacing: 7.0,
                        runSpacing: 2.0,
                        children: options.asMap().entries.map((entry) {
                          final index = entry.key;
                          final label = entry.value;
                          final isSelected = selectedIndexes.contains(index);
                          return ChoiceChip(
                            label: Text(label),
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
                      const SizedBox(height: 15.0),
                      Text(
                        '1개 이상 선택해주세요.',
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/const/colors.dart';
import 'package:frontend/signup/model/sign_up_request_model.dart';

class SignUpTasteDishPreferListScreen extends StatefulWidget {
  final Function({
  required List<int> favoriteDishIds,
  required List<int> favoriteTasteIds,
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
    'common.dishes.kimchi_stew',
    'common.dishes.soybean_paste_stew',
    'common.dishes.bibimbap',
    'common.dishes.bulgogi',
    'common.dishes.galbi',
    'common.dishes.samgyetang',
    'common.dishes.japchae',
    'common.dishes.gimbap',
    'common.dishes.galbitang',
    'common.dishes.kalguksu',
  ];
  final List<String> tasteOptions = [
    'common.tastes.spicy',
    'common.tastes.salty',
    'common.tastes.sweet',
    'common.tastes.bitter',
    'common.tastes.sour',
    'common.tastes.umami',
  ];

  List<int> selectedDishes = [];
  List<int> selectedTastes = [];

  @override
  void initState() {
    super.initState();
    final calculatedDish = widget.initialData?.favoriteDishIds.map((i) => i - 1);
    final calculatedTaste = widget.initialData?.favoriteTasteIds.map((i) => i - 1);

    selectedDishes = List<int>.from(calculatedDish ?? []);
    selectedTastes = List<int>.from(calculatedTaste ?? []);
  }

  void onSkipPressed() {
    widget.onComplete(
      favoriteDishIds: [],
      favoriteTasteIds: [],
    );
  }

  void onNextPressed() {
    widget.onComplete(
      favoriteDishIds: selectedDishes.map((index) => index + 1).toList(),
      favoriteTasteIds: selectedTastes.map((index) => index + 1).toList(),
    );
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
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr("common.favoriteTaste"),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 15.0),
                    Wrap(
                      children: tasteOptions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        final isSelected = selectedTastes.contains(index);
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
                                  selectedTastes.add(index);
                                } else {
                                  selectedTastes.remove(index);
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
                    const SizedBox(height: 30.0),
                    Text(
                      context.tr("common.favoriteDishes"),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 15.0),
                    Wrap(
                      children: dishOptions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        final isSelected = selectedDishes.contains(index);
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
                                  selectedDishes.add(index);
                                } else {
                                  selectedDishes.remove(index);
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
                  ],
                ),
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: onSkipPressed,
                  child: Center(
                    child: Text(
                      context.tr("signup.pass"),
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
                SizedBox(height: bottomInset > 0 ? bottomInset : 32.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

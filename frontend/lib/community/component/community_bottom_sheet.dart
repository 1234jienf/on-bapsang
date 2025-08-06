import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class SheetAction {
  final String label;
  final IconData icon;
  final Future<void> Function()? onTap;
  final Color? color;
  final bool showDividerBelow;

  const SheetAction({
    required this.label,
    required this.icon,
    this.onTap,
    this.color,
    this.showDividerBelow = true,
  });
}

Future<void> communityBottomSheet(
    BuildContext context, {
      required List<SheetAction> actions,
    }) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      final size = MediaQuery.of(sheetContext).size;
      return Container(
        width: size.width,
        height: size.height * 1 / 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ...[
                for (int i = 0; i < actions.length; i++) ...[
                  InkWell(
                    onTap: () async {
                      final fn = actions[i].onTap;
                      if (fn != null) {
                        await fn();
                      }
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(actions[i].icon,
                              size: 18, color: actions[i].color ?? gray900),
                          const SizedBox(width: 12),
                          Text(
                            actions[i].label,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: actions[i].color ?? gray900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6.0,),
                  if (actions[i].showDividerBelow)
                    Divider(color: gray400, height: 1),
                  const SizedBox(height: 6.0,),
                ],
              ],
            ],
          ),
        ),
      );
    },
  );
}
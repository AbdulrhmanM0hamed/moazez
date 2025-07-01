import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class StagesSelectorSection extends StatelessWidget {
  final int totalStages;
  final Function(int) onStagesChanged;

  const StagesSelectorSection({
    super.key,
    required this.totalStages,
    required this.onStagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'عدد المراحل',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: ElevatedButton(
                onPressed:
                    totalStages > 1
                        ? () {
                          onStagesChanged(totalStages - 1);
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary,
                ),
                child: const Icon(Icons.remove, color: Color.fromARGB(255, 170, 170, 170), size: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$totalStages',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size16,
                ),
              ),
            ),
            SizedBox(
              width: 25,
              height: 25,
              child: ElevatedButton(
                onPressed: () {
                  onStagesChanged(totalStages + 1);
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primary,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

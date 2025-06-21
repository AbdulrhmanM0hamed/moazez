import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';

class InviteParticipantsSection extends StatelessWidget {
  const InviteParticipantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const double chartHeight = 120;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SizedBox(
          height: 200, // Provide a fixed height for the container
          child: Stack(
            children: [
              // Background bars
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: chartHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(10, (index) {
                      final heights = [
                        0.8,
                        0.9,
                        0.9,
                        0.8,
                        0.7,
                        0.6,
                        0.5,
                        0.4,
                        0.3,
                        0.9,
                      ];
                      return Container(
                        width: 12,
                        height: chartHeight * heights[index],
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              // Foreground content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'أنت غير متفق مع أى مشاركين',
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'اضغط لدعوة المشاركين',
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: CustomButton(
                        onPressed: () {
                          // TODO: Implement invite action
                        },
                        text: 'إرسال دعوة',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

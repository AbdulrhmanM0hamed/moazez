import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/invitations/presentation/send_invitations_view.dart';

class InviteParticipantsSection extends StatelessWidget {
  const InviteParticipantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const double chartHeight = 140;

    return Container(
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
        height: 260, // Provide a fixed height for the container
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
                      0.7,
                      0.4,
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
                  SvgPicture.asset(
                    'assets/images/participants.svg',
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أنت غير متفق مع أى مشاركين',
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 16,
                      
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط لدعوة المشاركين',
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SendInvitationsView(),
                          ),
                        );
                      },
                      text: 'دعوة المشاركين',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

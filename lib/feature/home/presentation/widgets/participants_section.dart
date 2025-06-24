import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class ParticipantsSection extends StatelessWidget {
  const ParticipantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // List of avatar images (using a longer list for the grid)
    final List<String> participantAvatars = List.generate(
      8,
      (_) => 'assets/images/avatar.jpg',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Text(
                'المشاركون لديك',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تابع تقدمهم وتفاعل معهم',
                style: getRegularStyle(
                  fontFamily: FontConstant.cairo,
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              // Participants Grid
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: participantAvatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  return CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(participantAvatars[index]),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Add Button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 32),
              onPressed: () {
                // TODO: Implement add participant action
              },
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/animations/custom_animations.dart';
import 'package:moazez/feature/guest/data/models/dummy_member_stats_entity.dart';

class GuestParticipantsSection extends StatelessWidget {
  const GuestParticipantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyStats = DummyMemberStatsData.getDummyMemberStats();
    final members = dummyStats.members;

    if (members.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/epmtyData.svg',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد بيانات لعرضها حاليًا، حاول لاحقًا!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return CustomAnimations.scaleIn(
      duration: const Duration(milliseconds: 600),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 60,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                ),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ClipOval(
                    child: Image.network(
                      member.avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          'assets/images/defualt_avatar.svg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
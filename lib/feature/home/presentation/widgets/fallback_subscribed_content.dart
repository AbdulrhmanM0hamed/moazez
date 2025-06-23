import 'package:flutter/material.dart';
import 'package:moazez/feature/home/presentation/widgets/home_top_section.dart';
import 'package:moazez/feature/home/presentation/widgets/subscribed_content.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';

class FallbackSubscribedContent extends StatelessWidget {
  const FallbackSubscribedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeTopSection(),
        const SizedBox(height: 24),
        Expanded(
          child: SubscribedContent(
            trialPackage: PackageEntity(
              id: 0,
              name: '',
              description: '',
              price: '',
              priceFormatted: '',
              durationDays: 0,
              durationText: '',
              maxTasks: 0,
              maxTasksText: '',
              maxTeamMembers: 0,
              maxTeamMembersText: '',
              features: [],
              isTrial: false,
              isPopular: false,
              badge: '',
            ),
            packages: [],
            scrollController: ScrollController(),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:moazez/feature/agreements/domain/entities/agreement_entity.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreement_card.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreement_filter_tabs.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/home_top_section.dart';

class AgreementsViewBody extends StatefulWidget {
  const AgreementsViewBody({super.key});

  @override
  State<AgreementsViewBody> createState() => _AgreementsViewBodyState();
}

class _AgreementsViewBodyState extends State<AgreementsViewBody> {
  int _selectedFilterIndex = 0;

  // Dummy data for demonstration
  final List<AgreementEntity> _currentAgreements = [
    const AgreementEntity(
      id: '1',
      title: 'حفظ سورة النبأ',
      dateRange: '17/6 - 24/6',
      progress: 0.7,
      totalStages: 5,
      completedStages: 3,
      participantImageUrls: [
        'https://randomuser.me/api/portraits/women/1.jpg',
        'https://randomuser.me/api/portraits/men/2.jpg',
        'https://randomuser.me/api/portraits/women/3.jpg',
      ],
    ),
    const AgreementEntity(
      id: '2',
      title: 'مراجعة التقارير الشهرية',
      dateRange: '17/6 - 24/6',
      progress: 0.76,
      totalStages: 3,
      completedStages: 2,
      participantImageUrls: [
        'https://randomuser.me/api/portraits/men/4.jpg',
        'https://randomuser.me/api/portraits/women/5.jpg',
      ],
    ),
  ];

  final List<AgreementEntity> _pastAgreements = [
    const AgreementEntity(
      id: '3',
      title: 'تصميم الهوية البصرية',
      dateRange: '1/5 - 30/5',
      progress: 1.0,
      totalStages: 4,
      completedStages: 4,
      participantImageUrls: [
        'https://randomuser.me/api/portraits/men/6.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final agreementsToShow = _selectedFilterIndex == 0 ? _currentAgreements : _pastAgreements;

    return Column(
      children: [
        const HomeTopSection(),
        const SizedBox(height: 24),
        AgreementFilterTabs(
          selectedIndex: _selectedFilterIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedFilterIndex = index;
            });
          },
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: agreementsToShow.length,
            itemBuilder: (context, index) {
              return AgreementCard(
                agreement: agreementsToShow[index],
                onTap: () {
                  // ignore: avoid_print
                  print('Tapped on: ${agreementsToShow[index].title}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}


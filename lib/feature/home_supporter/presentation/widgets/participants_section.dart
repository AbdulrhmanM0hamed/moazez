import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_state.dart';

class ParticipantsSection extends StatelessWidget {
  const ParticipantsSection({super.key});

  // Function to convert percentage string to double (0 to 1)
  double _parsePercentage(String percentage) {
    // Remove '%' if present and convert to double
    final cleaned = percentage.replaceAll('%', '');
    final value = double.tryParse(cleaned) ?? 0.0;
    // Convert to 0-1 range if it's in 0-100 range
    return value > 1.0 ? value / 100.0 : value;
  }

  @override
  Widget build(BuildContext context) {
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
              // Participants Grid using BlocBuilder to get data
              BlocBuilder<MemberStatsCubit, MemberStatsState>(
                builder: (context, state) {
                  if (state is MemberStatsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MemberStatsLoaded) {
                    final members = state.response.members;
                    if (members.isEmpty) {
                      return const Center(child: Text('لا يوجد مشاركين'));
                    }
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final percent = _parsePercentage(member.stats.completionPercentageMargin);
                        return Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(member.avatarUrl),
                                  onBackgroundImageError: (exception, stackTrace) => const AssetImage('assets/images/avatar.jpg'),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${(percent * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              member.name.split(' ').first, // Display first name only
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is MemberStatsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text('يرجى تحميل البيانات'));
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

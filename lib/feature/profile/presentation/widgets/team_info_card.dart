import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';

class TeamInfoCard extends StatelessWidget {
  final String teamName;
  final int membersCount;
  final bool isOwner;
  final TextEditingController teamNameController;
  final Function(bool) onUpdatingStateChange;

  const TeamInfoCard({
    Key? key,
    required this.teamName,
    required this.membersCount,
    required this.isOwner,
    required this.teamNameController,
    required this.onUpdatingStateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).cardColor,
            Theme.of(context).cardColor.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'معلومات الفريق',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              // Infer ownership from TeamCubit state if possible
              Builder(
                builder: (context) {
                  final teamState = context.watch<TeamCubit>().state;
                  bool inferredOwner = isOwner;
                  if (teamState is TeamLoaded) {
                    inferredOwner = (teamState as TeamLoaded).team.id != null;
                  }
                  if (inferredOwner) {
                    return IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              title: const Text('تعديل اسم الفريق'),
                              content: CustomTextField(
                                controller: teamNameController,
                                hint: 'اسم الفريق الجديد',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (teamNameController.text.isNotEmpty) {
                                      final teamCubit = BlocProvider.of<TeamCubit>(context);
                                      teamCubit.updateTeamName(teamNameController.text);
                                      Navigator.of(dialogContext).pop();
                                      // Set updating state to show loading indicator
                                      onUpdatingStateChange(true);
                                      // Fetch team info after a short delay to refresh data
                                      Future.delayed(const Duration(seconds: 1), () {
                                        teamCubit.fetchTeamInfo();
                                      });
                                    } else {
                                      CustomSnackbar.show(
                                        context: dialogContext,
                                        message: 'يرجى إدخال اسم للفريق',
                                        isError: true,
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'حفظ',
                                    style: TextStyle(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'اسم الفريق',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      teamName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'عدد الأعضاء',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      membersCount.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

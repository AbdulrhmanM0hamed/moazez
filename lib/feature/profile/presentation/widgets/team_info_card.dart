import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'معلومات الفريق',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                                CustomDialogButton(
                                  text: 'إلغاء',
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  isDestructive: true,
                                ),
                                CustomDialogButton(
                                  text: 'حفظ',
                                  backgroundColor: AppColors.success,
                                  onPressed: () {
                                    if (teamNameController.text.isNotEmpty) {
                                      final teamCubit =
                                          BlocProvider.of<TeamCubit>(context);
                                      teamCubit.updateTeamName(
                                        teamNameController.text,
                                      );
                                      Navigator.of(dialogContext).pop();
                                      // Set updating state to show loading indicator
                                      onUpdatingStateChange(true);
                                      // Fetch team info after a short delay to refresh data
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          teamCubit.fetchTeamInfo();
                                        },
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        context: dialogContext,
                                        message: 'يرجى إدخال اسم للفريق',
                                        isError: true,
                                      );
                                    }
                                  },
                                  textColor: AppColors.white,
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
                    Text(
                      'اسم الفريق',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                      ),
                    ),
                    Text(
                      teamName,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
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
                    Text(
                      'عدد الأعضاء',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
                      ),
                    ),
                    Text(
                      membersCount.toString(),
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size16,
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

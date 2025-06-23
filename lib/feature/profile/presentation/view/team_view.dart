import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/cubit/team_state.dart';
import 'package:moazez/feature/home/domain/entities/team_entity.dart';

class TeamView extends StatelessWidget {
  const TeamView({super.key});

  static const String routeName = '/team';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeamCubit>()..fetchTeamInfo(),
      child: const _TeamViewBody(),
    );
  }
}

class _TeamViewBody extends StatefulWidget {
  const _TeamViewBody();

  @override
  _TeamViewBodyState createState() => _TeamViewBodyState();
}

class _TeamViewBodyState extends State<_TeamViewBody> {
  bool _isUpdating = false;
  TeamEntity? _currentTeam;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        title: const Text(
          'الفريق',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<TeamCubit, TeamState>(
        listener: (context, state) {
          if (state is TeamError) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              isError: true,
            );
            debugPrint('Team Error: ${state.message}');
            setState(() {
              _isUpdating = false;
            });
          } else if (state is TeamLoading) {
            debugPrint('Team Loading...');
          } else if (state is TeamLoaded) {
            debugPrint('Team Loaded: ${state.team.name}, Members: ${state.team.membersCount}');
            setState(() {
              _currentTeam = state.team;
              _isUpdating = false;
            });
          } else {
            debugPrint('Team State: Unknown or Initial');
          }
        },
        builder: (context, state) {
          if (state is TeamLoading || _isUpdating) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is TeamLoaded || _currentTeam != null) {
            final teamToDisplay = _currentTeam ?? (state as TeamLoaded).team;
            return _buildTeamContent(
              context,
              teamToDisplay.name ?? 'فريق غير مسمى',
              teamToDisplay.membersCount ?? 0,
              teamToDisplay.isOwner ?? false,
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'لا توجد بيانات للفريق',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<TeamCubit>().fetchTeamInfo(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamContent(
    BuildContext context,
    String teamName,
    int membersCount,
    bool isOwner,
  ) {
    final TextEditingController teamNameController = TextEditingController(
      text: teamName,
    );
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isOwner)
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary, size: 28),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                                    child: const Text('إلغاء', style: TextStyle(color: AppColors.textSecondary)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (teamNameController.text.isNotEmpty) {
                                        BlocProvider.of<TeamCubit>(context).updateTeamName(
                                          teamNameController.text,
                                        );
                                        Navigator.of(dialogContext).pop();
                                        // Show success snackbar immediately after update
                                        CustomSnackbar.show(
                                          context: context,
                                          message: 'تم تعديل اسم الفريق بنجاح',
                                          isError: false,
                                        );
                                        // Set updating state to show loading indicator
                                        setState(() {
                                          _isUpdating = true;
                                        });
                                        // Fetch full team info after update to ensure members data is refreshed
                                        BlocProvider.of<TeamCubit>(context).fetchTeamInfo();
                                      } else {
                                        CustomSnackbar.show(
                                          context: dialogContext,
                                          message: 'يرجى إدخال اسم للفريق',
                                          isError: true,
                                        );
                                      }
                                    },
                                    child: const Text('حفظ', style: TextStyle(color: AppColors.primary)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.group, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'اسم الفريق: $teamName',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'عدد الأعضاء: $membersCount',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'قائمة الأعضاء',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<TeamCubit, TeamState>(
                  builder: (context, state) {
                    if (state is TeamLoaded && state.team.members != null && state.team.members!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.team.members!.length,
                        itemBuilder: (context, index) {
                          final member = state.team.members![index];
                          if (member is Map<String, dynamic>) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline, color: AppColors.primary, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          member['name'] as String? ?? 'عضو بدون اسم',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        if (member['email'] != null)
                                          Text(
                                            member['email'] as String,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    } else {
                      return const Text(
                        'لا توجد بيانات عن الأعضاء حاليًا.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      BlocProvider.of<TeamCubit>(context).fetchTeamInfo();
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('تحديث القائمة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

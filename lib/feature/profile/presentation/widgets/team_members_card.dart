import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';

class TeamMembersCard extends StatefulWidget {
  final TeamEntity? team;

  const TeamMembersCard({Key? key, this.team}) : super(key: key);

  @override
  _TeamMembersCardState createState() => _TeamMembersCardState();
}

class _TeamMembersCardState extends State<TeamMembersCard> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TeamCubit, TeamState>(
      listener: (context, state) {
        if (state is TeamLoaded && _isDeleting) {
          CustomSnackbar.showSuccess(
            context: context,
            message: 'تم حذف العضو بنجاح',
          );
          setState(() {
            _isDeleting = false;
          });
        } else if (state is TeamError && _isDeleting) {
          CustomSnackbar.showError(context: context, message: state.message);
          setState(() {
            _isDeleting = false;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 16.0,
        ),
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
                  'قائمة الأعضاء',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  onPressed:
                      () => BlocProvider.of<TeamCubit>(context).fetchTeamInfo(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMembersList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(BuildContext context) {
    if (widget.team != null &&
        widget.team!.members != null &&
        widget.team!.members!.isNotEmpty) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.team!.members!.length,
        itemBuilder: (context, index) {
          final member = widget.team!.members![index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                member.avatarUrl != null && member.avatarUrl!.isNotEmpty
                    ? CustomCachedNetworkImage(
                      imageUrl: _fixAvatarUrl(member.avatarUrl!),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(25),
                      errorWidget: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        child: Center(
                          child: Text(
                            (member.name ?? 'ع').substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                    : SvgPicture.asset(
                      'assets/images/defualt_avatar.svg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name ?? 'عضو بدون اسم',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 8),
                      if (member.email != null)
                        Text(
                          member.email!,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size14,
                          ),
                        ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'تأكيد حذف العضو',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            'هل أنت متأكد أنك تريد حذف ${member.name ?? 'هذا العضو'} من الفريق؟',
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: <Widget>[
                            CustomDialogButton(
                              text: 'إلغاء',
                              onPressed: () {
                                Navigator.of(
                                  dialogContext,
                                ).pop(); // Close the dialog
                              },
                            ),
                            const SizedBox(width: 16),
                            CustomDialogButton(
                              text: 'تأكيد',
                              backgroundColor: AppColors.error,
                              onPressed: () {
                                Navigator.of(
                                  dialogContext,
                                ).pop(); // Close the dialog
                                setState(() {
                                  _isDeleting = true;
                                });
                                context.read<TeamCubit>().removeTeamMember(
                                  member.id,
                                );
                              },
                              isDestructive: true,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    "assets/images/trash.svg",
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      AppColors.error,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Column(
        children: [
          const Text(
            'لا توجد بيانات عن الأعضاء حاليًا.',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  String _fixAvatarUrl(String url) {
    // Fix for URLs that have double 'https://www.moezez.com'
    if (url.contains('https://www.moezez.comhttps://www.moezez.com')) {
      return url.replaceFirst(
        'https://www.moezez.comhttps://www.moezez.com',
        'https://www.moezez.com',
      );
    }
    return url;
  }
}

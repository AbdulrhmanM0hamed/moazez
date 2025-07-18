import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/profile/presentation/widgets/team_member_tile.dart';

class TeamMembersCard extends StatefulWidget {
  final TeamEntity? team;
  final List<TeamMemberModel> members;

  const TeamMembersCard({
    super.key,
    required this.team,
    required this.members,
  });

  @override
  State<TeamMembersCard> createState() => _TeamMembersCardState();
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
                  onPressed: () => context.read<TeamCubit>().fetchTeamInfo(),
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
    if (widget.members.isEmpty) {
      return const Center(
        child: Text(
          'لا يوجد أعضاء في الفريق حالياً',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.members.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = widget.members[index];
        return TeamMemberTile(
          member: member,
          isOwner: widget.team?.isOwner ?? false,
          onDelete: () async {
            setState(() {
              _isDeleting = true;
            });
            context.read<TeamCubit>().removeTeamMember(member.id);
          },
        );
      },
    );
  }
}

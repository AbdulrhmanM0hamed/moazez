import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_state.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';

class SentInvitationsView extends StatelessWidget {
  const SentInvitationsView({super.key});
  static const routeName = '/sent_invitations';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'الدعوات المرسلة',
        centerTitle: true,
      ),
      body: BlocBuilder<InvitationCubit, InvitationState>(
        builder: (context, state) {
          if (state is InvitationLoading) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is SentInvitationsLoaded) {
            final invitations = state.invitations;
            if (invitations.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد دعوات مرسلة',
                  style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return InvitationCard(invitation: invitation);
              },
            );
          } else if (state is InvitationError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: AppColors.error, fontSize: 16),
              ),
            );
          }
          return const Center(child: Text('تحميل الدعوات...'));
        },
      ),
    );
  }
}

class InvitationCard extends StatelessWidget {
  final InvitationEntity invitation;

  const InvitationCard({super.key, required this.invitation});

  @override
  Widget build(BuildContext context) {
    final isAccepted = invitation.status == "accepted";
    final isPending = invitation.status == "pending";
    final isRejected = invitation.status == "rejected";

    final Color statusColor = isAccepted
        ? AppColors.success
        : isPending
            ? AppColors.warning
            : AppColors.error;

    final IconData statusIcon = isAccepted
        ? Icons.check_circle_outline
        : isPending
            ? Icons.hourglass_bottom
            : Icons.cancel_outlined;

    final String statusText = isAccepted
        ? "مقبول"
        : isPending
            ? "قيد الانتظار"
            : "مرفوض";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.4), width: 1.5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar or Icon section
            invitation.user.avatarUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(invitation.user.avatarUrl),
                    onBackgroundImageError: (_, __) => Icon(
                      statusIcon,
                      color: statusColor,
                      size: 30,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withOpacity(0.1),
                    ),
                    child: Icon(
                      statusIcon,
                      color: statusColor,
                      size: 30,
                    ),
                  ),
            const SizedBox(width: 16),

            // Info section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.user.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.group, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'الفريق: ${invitation.team.name}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        'الحالة: $statusText',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
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
      appBar: CustomAppBar(title: 'الدعوات المرسلة', centerTitle: true),
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
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
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

    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (isAccepted) {
      statusColor = AppColors.success;
      statusText = "مقبول";
      statusIcon = Icons.check_circle;
    } else if (isPending) {
      statusColor = AppColors.warning;
      statusText = "قيد الانتظار";
      statusIcon = Icons.hourglass_empty;
    } else {
      statusColor = AppColors.error;
      statusText = "مرفوض";
      statusIcon = Icons.cancel;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Avatar
            CustomCachedNetworkImage(
              imageUrl: invitation.user.avatarUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(32),
              errorWidget: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textSecondary.withOpacity(0.1),
                ),
                child: const Icon(Icons.person_off_outlined,
                    color: AppColors.textSecondary, size: 30),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invitation.user.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الفريق: ${invitation.team.name}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Status
            _StatusIndicator(
              statusText: statusText,
              statusColor: statusColor,
              statusIcon: statusIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String statusText;
  final Color statusColor;
  final IconData statusIcon;

  const _StatusIndicator({
    required this.statusText,
    required this.statusColor,
    required this.statusIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, color: statusColor, size: 16),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

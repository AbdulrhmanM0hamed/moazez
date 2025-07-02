import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_state.dart';

class ReceivedInvitationsView extends StatelessWidget {
  const ReceivedInvitationsView({super.key});

  static const String routeName = '/received_invitations';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InvitationCubit>()..getReceivedInvitations(),
      child: const _ReceivedInvitationsViewBody(),
    );
  }
}

class _ReceivedInvitationsViewBody extends StatelessWidget {
  const _ReceivedInvitationsViewBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'طلبات الانضمام المستلمة'),
      body: BlocConsumer<InvitationCubit, InvitationState>(
        listener: (context, state) {
          if (state is InvitationError) {
            print(state.message);
            CustomSnackbar.showError(context: context, message: state.message);
          } else if (state is InvitationResponded) {
            CustomSnackbar.showSuccess(
              context: context,
              message:
                  state.action == 'accept'
                      ? 'تم قبول الطلب بنجاح'
                      : 'تم رفض الطلب بنجاح',
            );
            context.read<InvitationCubit>().getReceivedInvitations();
          }
        },
        builder: (context, state) {
          if (state is InvitationLoading) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is ReceivedInvitationsLoaded) {
            final invitations = state.invitations;
            if (invitations.isEmpty) {
              return const Center(
                child: Text(
                  'لا توجد طلبات انضمام مستلمة حاليًا.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: invitations.length,
              itemBuilder: (context, index) {
                final invitation = invitations[index];
                return Card(
                  elevation: 6,
                  shadowColor: Colors.black.withValues(alpha: 0.1),
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child:
                              invitation.user.avatarUrl != null
                                  ? CustomCachedNetworkImage(
                                    imageUrl: invitation.user.avatarUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorWidget: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/images/defualt_avatar.svg',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                  : SvgPicture.asset(
                                    'assets/images/defualt_avatar.svg',
                                    width: 60,
                                    height: 60,
                                  ),
                        ),
                        const SizedBox(width: 16),

                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                invitation.senderName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'يريد ضمك الى فريقه: ${invitation.team.name}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Actions or Status
                        invitation.status == 'pending'
                            ? Row(
                              children: [
                                Tooltip(
                                  message: 'قبول الطلب',
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<InvitationCubit>()
                                          .respondToInvitation(
                                            invitation.id.toString(),
                                            'accept',
                                          );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Tooltip(
                                  message: 'رفض الطلب',
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<InvitationCubit>()
                                          .respondToInvitation(
                                            invitation.id.toString(),
                                            'reject',
                                          );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              invitation.status == 'accepted'
                                  ? 'تم القبول'
                                  : 'تم الرفض',
                              style: TextStyle(
                                color:
                                    invitation.status == 'accepted'
                                        ? Colors.green
                                        : AppColors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text(
              'حدث خطأ أثناء تحميل البيانات.',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:moazez/feature/invitations/presentation/received_invitations_view.dart';
import 'package:moazez/feature/invitations/presentation/sent_invitations_view.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 8),
      child: Row(
        children: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                final user = state.profileResponse.data.user;
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child:
                          user.avatarUrl != null && user.avatarUrl != ''
                              ? CustomCachedNetworkImage(
                                imageUrl: user.avatarUrl!,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(32),
                              )
                              : SvgPicture.asset(
                                'assets/images/defualt_avatar.svg',
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'هلا ${user.name}',
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                      ),
                    ),
                  ],
                );
              } else if (state is ProfileLoading) {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(width: 80, height: 18, color: Colors.grey[300]),
                  ],
                );
              } else {
                return Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: SvgPicture.asset(
                        'assets/images/defualt_avatar.svg',
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'مرحبا',
                      style: getBoldStyle(
                        color: AppColors.white,
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size20,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const Spacer(),
          // Invitations icon with badge for both Participant and Supporter
          FutureBuilder<String?>(
            future: sl<CacheService>().getUserRole(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 'Participant') {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ReceivedInvitationsView.routeName,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.info.withValues(alpha: 0.2),
                            border: Border.all(
                              color: AppColors.info.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "دعوات الانضمام",
                                style: getMediumStyle(
                                  color: Colors.white,
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/request.svg', // Ensure this asset exists or replace with an appropriate icon
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.data == 'Supporter') {
                  return BlocBuilder<TeamCubit, TeamState>(
                    builder: (context, teamState) {
                      bool ownsTeam = false;
                      if (teamState is TeamLoaded) {
                        final loadedState = teamState;
                        ownsTeam = loadedState.team.isOwner;
                      } else if (teamState is TeamError) {
                        final errorState = teamState;
                        if (errorState.message.contains("لا تملك فريقاً")) {
                          ownsTeam = false;
                        }
                      }
                      if (ownsTeam) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider(
                                          create:
                                              (context) =>
                                                  sl<InvitationCubit>()
                                                    ..getSentInvitations(),
                                          child: const SentInvitationsView(),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.info.withValues(alpha: 0.2),
                                  border: Border.all(
                                    color: AppColors.info.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),

                                child: Row(
                                  children: [
                                    Text(
                                      "الدعوات المُرسلة",
                                      style: getMediumStyle(
                                        color: Colors.white,
                                        fontFamily: FontConstant.cairo,
                                        fontSize: FontSize.size14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.send_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

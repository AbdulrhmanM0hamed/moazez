import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/home_supporter/presentation/widgets/packages_view.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_cubit.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/feature/invitations/presentation/send_invitations_view.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_cubit.dart';
import 'package:moazez/feature/packages/presentation/cubit/payment_state.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/packages/presentation/view/payment_webview.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';

class HomeSupporterViewBody extends StatefulWidget {
  const HomeSupporterViewBody({super.key});

  @override
  State<HomeSupporterViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeSupporterViewBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
        await SystemNavigator.pop();
        return false;
      },
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          context.read<ProfileCubit>().fetchProfile();
          context.read<TeamCubit>().fetchTeamInfo();
          await Future.delayed(const Duration(milliseconds: 1500));
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoading) {
              return const Center(child: CustomProgressIndcator());
            }
            if (profileState is ProfileError) {
              if (profileState.message.contains('Unauthenticated.')) {
                return const UnauthenticatedWidget();
              }
              return Center(
                child: Text(
                  profileState.message,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }
            if (profileState is ProfileLoaded) {
              return BlocBuilder<TeamCubit, TeamState>(
                builder: (context, teamState) {
                  if (teamState is TeamLoading) {
                    return const Center(child: CustomProgressIndcator());
                  }

                  if (teamState is TeamError && 
                      teamState.message.contains('Unauthenticated.')) {
                    return const UnauthenticatedWidget();
                  }

                  bool ownsTeam = false;
                  if (teamState is TeamLoaded) {
                    ownsTeam = teamState.team.isOwner;
                  } else if (teamState is TeamError) {
                    if (teamState.message.contains("لا تملك فريقاً")) {
                      ownsTeam = false;
                    }
                  }

                  return Stack(
                    children: [
                      MultiBlocProvider(
                        providers: [
                          BlocProvider<SubscriptionCubit>(
                            create:
                                (context) =>
                                    sl<SubscriptionCubit>()
                                      ..fetchCurrentSubscription(),
                          ),
                          BlocProvider<PaymentCubit>(
                            create: (context) => sl<PaymentCubit>(),
                          ),
                        ],
                        child: BlocListener<PaymentCubit, PaymentState>(
                          listener: (context, paymentState) {
                            final homeContext = context;
                            if (paymentState is PaymentSuccess) {
                              if (paymentState.paymentUrl == null ||
                                  paymentState.paymentUrl!.isEmpty) {
                                homeContext
                                    .read<PaymentCubit>()
                                    .updateSubscriptionAfterPayment();
                                CustomSnackbar.showSuccess(
                                  context: homeContext,
                                  message: 'تم تفعيل الباقة بنجاح',
                                );
                                // Refresh the home page
                                homeContext.read<ProfileCubit>().fetchProfile();
                                homeContext.read<TeamCubit>().fetchTeamInfo();
                                homeContext
                                    .read<SubscriptionCubit>()
                                    .fetchCurrentSubscription();
                                return;
                              }

                              CustomSnackbar.showSuccess(
                                context: homeContext,
                                message: 'جارٍ تحويلك إلى صفحة الدفع...',
                              );

                              Future.delayed(const Duration(seconds: 1), () {
                                final paymentCubit =
                                    homeContext.read<PaymentCubit>();
                                final scaffoldMessengerState =
                                    ScaffoldMessenger.of(homeContext);
                                Navigator.push(
                                  homeContext,
                                  MaterialPageRoute(
                                    builder:
                                        (navContext) => BlocProvider.value(
                                          value: paymentCubit,
                                          child: PaymentWebView(
                                            paymentUrl:
                                                paymentState.paymentUrl ?? '',
                                            onPaymentComplete: (bool success) {
                                              Future.microtask(() {
                                                if (Navigator.canPop(
                                                  navContext,
                                                )) {
                                                  Navigator.of(
                                                    navContext,
                                                  ).pop();
                                                }

                                                scaffoldMessengerState
                                                    .clearSnackBars();
                                                CustomSnackbar.showSuccess(
                                                  context: homeContext,
                                                  message:
                                                      success
                                                          ? 'تمت عملية الدفع بنجاح! جارٍ تحديث اشتراكك...'
                                                          : 'تم إلغاء عملية الدفع، يرجى المحاولة مرة أخرى لاحقًا',
                                                );

                                                if (success) {
                                                  paymentCubit
                                                      .updateSubscriptionAfterPayment();
                                                  // Refresh the home page
                                                  homeContext
                                                      .read<ProfileCubit>()
                                                      .fetchProfile();
                                                  homeContext
                                                      .read<TeamCubit>()
                                                      .fetchTeamInfo();
                                                  homeContext
                                                      .read<SubscriptionCubit>()
                                                      .fetchCurrentSubscription();
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                  ),
                                );
                              });
                            } else if (paymentState is PaymentError) {
                              final bool isTooManyRequests =
                                  paymentState.message.contains(
                                    'لقد قمت بالعديد من المحاولات',
                                  ) ||
                                  paymentState.message.contains(
                                    'تجاوز الحد المسموح',
                                  );

                              final String userMessage =
                                  isTooManyRequests
                                      ? 'لقد قمت بالعديد من محاولات الدفع. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.'
                                      : paymentState.message;

                              CustomSnackbar.showError(
                                context: homeContext,
                                message: userMessage,
                              );
                            }
                          },
                          child: PackagesView(
                            profileState: profileState,
                            teamState: teamState,
                          ),
                        ),
                      ),
                      if (ownsTeam)
                        Positioned(
                          bottom: 1,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: AppColors.primary,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const SendInvitationsView(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }
            return const Center(child: CustomProgressIndcator());
          },
        ),
      ),
    );
  }
}

// return BlocBuilder<ProfileCubit, ProfileState>(
//   builder: (context, profileState) {
//     if (profileState is ProfileLoading) {
//       return const Center(child: CustomProgressIndcator());
//     }
//     if (profileState is ProfileLoaded) {
//       return BlocBuilder<TeamCubit, TeamState>(

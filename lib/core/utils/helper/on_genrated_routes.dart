import 'package:flutter/material.dart';
import 'package:moazez/feature/agreements/presentation/view/add_task_view.dart';
import 'package:moazez/feature/auth/presentation/pages/complete_profile_view.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/auth/presentation/pages/password_reset_link_view.dart';
import 'package:moazez/feature/auth/presentation/pages/signup_view.dart';
import 'package:moazez/feature/auth/presentation/pages/terms_and_privacy_view.dart';
import 'package:moazez/feature/home_participant/presentation/view/participants_nav_bar.dart';
import 'package:moazez/feature/home_supporter/presentation/view/create_team_view.dart';
import 'package:moazez/feature/home_supporter/presentation/view/supporter_nav_bar.dart';
import 'package:moazez/feature/invitations/presentation/received_invitations_view.dart';
import 'package:moazez/feature/invitations/presentation/sent_invitations_view.dart';
import 'package:moazez/feature/packages/presentation/view/packages_view.dart';
import 'package:moazez/feature/profile/presentation/view/subscriptions_view.dart';
import 'package:moazez/feature/profile/presentation/view/team_view.dart';
import 'package:moazez/feature/rewards/presentation/view/my_rewards_view.dart';
import 'package:moazez/feature/rewards/presentation/view/rewards_view.dart';
import 'package:moazez/feature/splash/presentation/splash_view.dart';
import 'package:moazez/feature/profile/presentation/view/edit_profile_info.dart';

import 'package:moazez/feature/onboarding/presentation/onboarding_view.dart';

Route<dynamic> onGenratedRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
    case OnboardingView.routeName:
      return MaterialPageRoute(builder: (context) => const OnboardingView());
    case SignUpView.routeName:
      return MaterialPageRoute(builder: (_) => const SignUpView());
    case AddTaskView.routeName:
      return MaterialPageRoute(builder: (context) => const AddTaskView());
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case CompleteProfileView.routeName:
      final args = settings.arguments as Map<String, String>;
      return MaterialPageRoute(
        builder: (context) => CompleteProfileView(signupData: args),
      );
    case SupporterNavBar.routeName:
      return MaterialPageRoute(builder: (context) => const SupporterNavBar());
    case ParticipantsNavBar.routeName:
      return MaterialPageRoute(
        builder: (context) => const ParticipantsNavBar(),
      );
    case TermsAndPrivacyView.routeName:
      return MaterialPageRoute(
        builder: (context) => const TermsAndPrivacyView(),
      );
    case EditProfileInfo.routeName:
      return MaterialPageRoute(builder: (context) => const EditProfileInfo());
    case CreateTeamView.routeName:
      return MaterialPageRoute(builder: (context) => const CreateTeamView());
    case TeamView.routeName:
      return MaterialPageRoute(builder: (context) => const TeamView());
    case PackagesView.routeName:
      return MaterialPageRoute(builder: (context) => const PackagesView());
    case PasswordResetLinkView.routeName:
      return MaterialPageRoute(builder: (context) => PasswordResetLinkView());
    case SentInvitationsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const SentInvitationsView(),
      );
    case SubscriptionsView.routeName:
      return MaterialPageRoute(builder: (context) => const SubscriptionsView());
    case ReceivedInvitationsView.routeName:
      return MaterialPageRoute(
        builder: (context) => const ReceivedInvitationsView(),
      );
    case RewardsView.routeName:
      return MaterialPageRoute(builder: (context) => const RewardsView());
    case MyRewardsView.routeName:
      return MaterialPageRoute(builder: (context) => const MyRewardsView());

    default:
      return MaterialPageRoute(builder: (context) => const SplashView());
  }
}

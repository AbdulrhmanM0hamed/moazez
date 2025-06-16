
// Route<dynamic> onGenratedRoutes(RouteSettings settings) {
//   switch (settings.name) {
//     case SplashView.routeName:
//       return MaterialPageRoute(
//         builder: (context) => const SplashView(),
//       );
//     case TermsAndPrivacyView.routeName:
//       return MaterialPageRoute(
//         builder: (context) => const TermsAndPrivacyView(),
//       );
//     case OnboardingView.routeName:
//       return MaterialPageRoute(
//         builder: (context) => const OnboardingView(),
//       );
//     case SigninView.routeName:
//       return MaterialPageRoute(
//         builder: (context) => const SigninView(),
//       );
//     case SignupView.routeName:
//       return MaterialPageRoute(
//         builder: (context) => const SignupView(),
//       );
//     case ForgotPasswordView.routeName:
//       return MaterialPageRoute(
//         builder: (_) => const ForgotPasswordView(),
//       );
//     // case NewPasswordView.routeName:
//     //   final args = settings.arguments as Map<String, String>;
//     //   return MaterialPageRoute(
//     //     builder: (_) => NewPasswordView(
//     //       token: args['token']!,
//     //       email: args['email']!,
//     //     ),
//     //   );
//     case HomeView.routeName:
//       return MaterialPageRoute(builder: (context) => const HomeView());
//     // case SalonProfileView.routeName:
//     //   final args = settings.arguments as Map<String, dynamic>;
//     //   return MaterialPageRoute(
//     //     builder: (context) => SalonProfileView(
//     //       salonId: args['salonId'] as int,
//     //     ),
//     //   );
//     case AddOrderView.routeName:
//       return MaterialPageRoute(
//         builder: (_) => BlocProvider(
//           create: (context) => sl<AddOrderCubit>(),
//           child: const AddOrderView(),
//         ),
//       );
//     default:
//       return MaterialPageRoute(
//         builder: (context) => const SplashView(),
//       );
//   }
// }

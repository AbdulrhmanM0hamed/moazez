// import 'package:flutter/material.dart';
// import 'package:moazez/core/utils/theme/app_colors.dart';
// import 'package:moazez/feature/home/presentation/widgets/subscription_prompt.dart';
// import 'package:moazez/feature/packages/domain/models/package_entity.dart';
// import 'package:moazez/feature/packages/presentation/widgets/package_card.dart';
// import 'package:moazez/feature/packages/presentation/widgets/packages_grid.dart';

// class NonSubscribedContent extends StatelessWidget {
//   final PackageEntity trialPackage;
//   final List<PackageEntity> packages;
//   final VoidCallback onSubscribePressed;
//   final ScrollController? scrollController;

//   const NonSubscribedContent({
//     super.key,
//     required this.trialPackage,
//     required this.packages,
//     required this.onSubscribePressed,
//     this.scrollController,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       controller: scrollController,
//       slivers: [
//         // Header Section with Subscription Prompt
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SubscriptionPrompt(onSubscribePressed: onSubscribePressed),
//                 const SizedBox(height: 32),
//                 _buildSectionTitle(
//                   'الباقة التجريبية',
//                   icon: Icons.rocket_launch_rounded,
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Trial Package
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 16,
//           ),
//           sliver: SliverToBoxAdapter(
//             child: PackageCard(
//               package: trialPackage,
//               isTrial: true,
//             ),
//           ),
//         ),

//         // Paid Packages Section
//         SliverPadding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           sliver: SliverToBoxAdapter(
//             child: _buildSectionTitle(
//               'الباقات المدفوعة',
//               icon: Icons.workspace_premium_rounded,
//             ),
//           ),
//         ),

//         // Paid Packages Grid
//         PackagesGrid(
//           packages: packages,
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title, {required IconData icon}) {
//     return Row(
//       children: [
//         Icon(icon, size: 24, color: AppColors.primary),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }

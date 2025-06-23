// import 'package:flutter/material.dart';
// import 'package:moazez/core/utils/constant/font_manger.dart';
// import 'package:moazez/core/utils/constant/styles_manger.dart';
// import 'package:moazez/core/utils/theme/app_colors.dart';
// import 'package:moazez/feature/profile/presentation/widgets/account_type_switcher.dart';

// class ProfileHeaderCard extends StatelessWidget {
//   const ProfileHeaderCard({
//     super.key,
//     required this.name,
//     required this.email,
//     this.imageUrl,
//   });

//   final String name;
//   final String email;
//   final String? imageUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30,
//             backgroundColor: AppColors.primary.withValues(alpha: 0.1),
//             backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
//             child:
//                 imageUrl == null
//                     ? const Icon(
//                       Icons.person,
//                       size: 30,
//                       color: AppColors.primary,
//                     )
//                     : null,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   name,
//                   style: getBoldStyle(
//                     color: AppColors.textPrimary,
//                     fontFamily: FontConstant.cairo,
//                     fontSize: 18,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   email,
//                   style: getRegularStyle(
//                     fontFamily: FontConstant.cairo,
//                     color: AppColors.grey,
//                     fontSize: 14,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 16),
//           const AccountTypeSwitcher(),
//         ],
//       ),
//     );
//   }
// }

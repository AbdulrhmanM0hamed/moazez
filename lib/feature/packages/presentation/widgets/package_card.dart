// import 'package:flutter/material.dart';
// import 'package:moazez/core/utils/common/custom_button.dart';
// import 'package:moazez/core/utils/constant/font_manger.dart';
// import 'package:moazez/core/utils/constant/styles_manger.dart';
// import 'package:moazez/core/utils/theme/app_colors.dart';
// import 'package:moazez/feature/packages/domain/models/package_entity.dart';

// class PackageCard extends StatelessWidget {
//   final PackageEntity package;
//   final bool isTrial;
//   final VoidCallback? onTap;

//   const PackageCard({
//     super.key,
//     required this.package,
//     this.isTrial = false,
//     this.onTap,
//   });

//   Color get _primaryColor =>
//       isTrial ? const Color(0xFF4CAF50) : AppColors.primary;
//   Color get _secondaryColor =>
//       isTrial ? const Color(0xFF388E3C) : AppColors.secondary;
//   Color get _backgroundColor => Colors.white;
//   Color get _textColor => const Color(0xFF333333);
//   Color get _labelColor => const Color(0xFF666666);

//   Icon _getIcon(String type) {
//     switch (type) {
//       case 'price':
//         return Icon(Icons.attach_money, color: _primaryColor, size: 24);
//       case 'tasks':
//         return Icon(Icons.task_alt, color: _primaryColor, size: 24);
//       case 'members':
//         return Icon(Icons.group, color: _primaryColor, size: 24);
//       default:
//         return Icon(Icons.check, color: _primaryColor, size: 20);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//       elevation: 8,
//       shadowColor: Colors.black12,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//         side: BorderSide(color: _primaryColor.withOpacity(0.25), width: 1.3),
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(20),
//         child: Column(
//           children: [
//             // Header with gradient
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [_primaryColor, _secondaryColor],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   package.name,
//                   style: getBoldStyle(
//                     fontFamily: FontConstant.cairo,
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),

//             // Price, Tasks, Members section
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//               color: _backgroundColor,
//               child: Row(
//                 children: [
//                   _buildInfoItem('price', 'السعر', package.priceFormatted),
//                   _verticalDivider(),
//                   _buildInfoItem('tasks', 'المهام', package.maxTasksText),
//                   _verticalDivider(),
//                   _buildInfoItem(
//                     'members',
//                     'الأعضاء',
//                     package.maxTeamMembersText,
//                   ),
//                 ],
//               ),
//             ),

//             // Features
//             if (package.features.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'المميزات',
//                       style: getSemiBoldStyle(fontFamily: FontConstant.cairo),
//                     ),
//                     const SizedBox(height: 12),
//                     ...package.features.map((feature) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 10),
//                         child: Row(
//                           children: [
//                             const Icon(
//                               Icons.check_circle_outline,
//                               color: Colors.green,
//                               size: 20,
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 feature,
//                                 style: getSemiBoldStyle(
//                                   fontFamily: FontConstant.cairo,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),

//             // Button
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 52,
//                 child: CustomButton(
//                   onPressed: onTap ?? () {},
//                   text: isTrial ? 'جرب الآن' : 'اشترك الآن',
//                   backgroundColor: isTrial ? Colors.green : AppColors.primary,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoItem(String type, String label, String value) {
//     return Expanded(
//       child: Column(
//         children: [
//           _getIcon(type),
//           const SizedBox(height: 2),
//           Text(label, style: getSemiBoldStyle(fontFamily: FontConstant.cairo)),
//           const SizedBox(height: 6),
//           Text(
//             value,
//             style: getSemiBoldStyle(
//               fontSize: 14,
//               fontFamily: FontConstant.cairo,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _verticalDivider() => Container(
//     height: 60,
//     width: 1,
//     color: Colors.grey.withOpacity(0.3),
//     margin: const EdgeInsets.symmetric(horizontal: 6),
//   );
// }

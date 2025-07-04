// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:moazez/core/utils/common/custom_button.dart';
// import 'package:moazez/core/utils/constant/font_manger.dart';
// import 'package:moazez/core/utils/constant/styles_manger.dart';

// class CreateTeamPrompt extends StatelessWidget {
//   final VoidCallback onPressed;

//   const CreateTeamPrompt({super.key, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(50.0),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.05),
//             blurRadius: 20,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             'assets/images/team.svg',
//             height: 170,
//             width: 170,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'لم تقم بإنشاء فريق بعد',
//             style: getSemiBoldStyle(
//               fontFamily: FontConstant.cairo,
//               fontSize: 18,
//               color: Colors.grey[800],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'اضغط لإنشاء فريق جديد وابدأ التعاون',
//             style: getRegularStyle(
//               fontFamily: FontConstant.cairo,
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             width: 250,
//             child: CustomButton(
//               onPressed: onPressed,
//               text: 'إنشاء فريق جديد',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

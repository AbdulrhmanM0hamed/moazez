import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMemberModel member;
  final bool isOwner;
  final VoidCallback onDelete;

  const TeamMemberTile({
    super.key,
    required this.member,
    required this.isOwner,
    required this.onDelete,
  });

  String _fixAvatarUrl(String url) {
    if (url.contains('https://www.moezez.comhttps://www.moezez.com')) {
      return url.replaceFirst(
        'https://www.moezez.comhttps://www.moezez.com',
        'https://www.moezez.com',
      );
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          member.avatarUrl != null && member.avatarUrl!.isNotEmpty
              ? CustomCachedNetworkImage(
                  imageUrl: _fixAvatarUrl(member.avatarUrl!),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(25),
                  errorWidget: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        (member.name).substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : SvgPicture.asset(
                  'assets/images/defualt_avatar.svg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                if (member.email != null)
                  Text(
                    member.email!,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size14,
                    ),
                  ),
              ],
            ),
          ),
          if (isOwner)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text(
                        'تأكيد حذف العضو',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'هل أنت متأكد أنك تريد حذف ${member.name} من الفريق؟',
                        textAlign: TextAlign.center,
                      ),
                      actionsAlignment: MainAxisAlignment.center,
                      actions: <Widget>[
                        CustomDialogButton(
                          text: 'إلغاء',
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                        const SizedBox(width: 16),
                        CustomDialogButton(
                          text: 'تأكيد',
                          backgroundColor: AppColors.error,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            onDelete();
                          },
                          isDestructive: true,
                        ),
                      ],
                    );
                  },
                );
              },
              child: SvgPicture.asset(
                "assets/images/trash.svg",
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.error,
                  BlendMode.srcIn,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 
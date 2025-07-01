import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/common/custom_dialog_button.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';

class TaskDetailsDialog extends StatelessWidget {
  final MemberStatsEntity member;
  final TaskEntity task;

  const TaskDetailsDialog({
    super.key,
    required this.member,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(child: _buildDialogContent(context)),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the dialog compact
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 24.0),
          Text(
            task.title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildProgressSection(context),
          const SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomDialogButton(
              text: "إغلاق",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          child: member.avatarUrl.isNotEmpty && Uri.tryParse(member.avatarUrl)?.hasAuthority == true
              ? CustomCachedNetworkImage(
                  imageUrl: member.avatarUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(24),
                )
              : SvgPicture.asset(
                  'assets/images/defualt_avatar.svg',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            member.name,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نسبة التقدم',
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: LinearPercentIndicator(
            lineHeight: 14.0,
            percent: task.progress / 100.0,
            isRTL: true, // Reverse the progress bar direction
            center: Text(
              '${task.progress}%',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            barRadius: const Radius.circular(7),
            backgroundColor: Colors.grey.shade300,
            linearGradient: const LinearGradient(
              colors: [Color.fromARGB(255, 15, 139, 161), Color(0xFF0DD0F4)],
            ),
          ),
        ),
      ],
    );
  }
}

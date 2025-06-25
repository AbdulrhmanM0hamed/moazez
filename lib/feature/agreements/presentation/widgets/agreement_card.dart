import 'package:flutter/material.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/feature/agreements/domain/entities/agreement_entity.dart';
import 'package:moazez/feature/agreements/presentation/widgets/gradient_progress_indicator.dart';
import 'package:moazez/feature/agreements/presentation/widgets/participants_stack.dart';

class AgreementCard extends StatelessWidget {
  final AgreementEntity agreement;
  final VoidCallback? onTap;

  const AgreementCard({super.key, required this.agreement, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildInfoRow(
              context,
              title: 'التقدم',
              value: '${(agreement.progress * 100).toInt()}%',
              indicator: GradientProgressIndicator(
                progress: agreement.progress,
                backgroundColor: theme.scaffoldBackgroundColor,
                gradient: const LinearGradient(
                  colors: [Color(0xFF0DD0F4), Color(0xFF006E82)],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(
              context,
              title: 'المراحل',
              value: '${agreement.completedStages} من ${agreement.totalStages}',
              indicator: _buildStagesIndicator(context),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المشاركين',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                ParticipantsStack(imageUrls: agreement.participantImageUrls),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            agreement.title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          agreement.dateRange,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.more_vert,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String title,
    String? value,
    required Widget indicator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            if (value != null)
              Text(
                value,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        indicator,
      ],
    );
  }

  Widget _buildStagesIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: List.generate(agreement.totalStages, (index) {
        final bool isCompleted = index < agreement.completedStages;
        return Expanded(
          child: Container(
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? Color.lerp(
                        const Color(0xFF006E82),
                        const Color(0xFF0DD0F4),
                        index / (agreement.totalStages - 1),
                      )
                      : theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

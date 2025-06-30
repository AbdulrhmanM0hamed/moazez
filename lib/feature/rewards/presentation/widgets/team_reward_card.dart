import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';

class TeamRewardCard extends StatelessWidget {
  final RewardEntity reward;
  const TeamRewardCard({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = double.tryParse(reward.amount) ?? 0.0;
    final isPositiveAmount = amount >= 0;
    final borderRadius = BorderRadius.circular(22);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            // Glassmorphism background
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.surface.withValues(alpha: 0.85),
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                      theme.colorScheme.secondary.withValues(alpha: 0.09),
                    ],
                  ),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.07),
                    width: 1.2,
                  ),
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.07),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: () {},
                    splashColor: theme.colorScheme.primary.withValues(
                      alpha: 0.07,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with avatar and user info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Hero(
                                tag: 'reward_avatar_${reward.id}',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      border: Border.all(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                        reward.user != null &&
                                                reward
                                                    .user!
                                                    .avatarUrl
                                                    .isNotEmpty
                                            ? CustomCachedNetworkImage(
                                              imageUrl: reward.user!.avatarUrl,
                                              fit: BoxFit.cover,
                                              placeholder: Icon(
                                                Icons.person,
                                                color: Colors.grey[600],
                                                size: 30,
                                              ),
                                              errorWidget: Icon(
                                                Icons.person,
                                                color: Colors.grey[600],
                                                size: 30,
                                              ),
                                            )
                                            : SvgPicture.asset(
                                              'assets/images/defualt_avatar.svg',
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                            ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reward.user != null
                                          ? reward.user!.name
                                          : 'Unknown User',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.6,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 350,
                                      ),
                                      child: Text(
                                        _formatDate(reward.createdAt),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.outline,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        key: ValueKey(reward.createdAt),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(reward.status, theme),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(
                                        reward.status,
                                        theme,
                                      ).withValues(alpha: 0.18),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  reward.status,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 0.5),

                          // Reward notes with improved typography
                          Text(
                            reward.notes,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                            ),
                          ),

                          // Amount or Description based on whether amount is non-zero
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color:
                                      amount != 0.0
                                          ? (isPositiveAmount
                                              ? Colors.green.withValues(
                                                alpha: 0.15,
                                              )
                                              : Colors.red.withValues(
                                                alpha: 0.16,
                                              ))
                                          : Colors.blue.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  amount != 0.0
                                      ? (isPositiveAmount
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded)
                                      : Icons.card_giftcard,
                                  color:
                                      amount != 0.0
                                          ? (isPositiveAmount
                                              ? Colors.green
                                              : Colors.red)
                                          : Colors.blue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    amount != 0.0 ? 'المبلغ' : 'الوصف',
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color: theme.colorScheme.outline,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    amount != 0.0
                                        ? '${isPositiveAmount ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}'
                                        : reward.rewardDescription,
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.cairo,
                                      fontSize: FontSize.size14,
                                      color:
                                          amount != 0.0
                                              ? (isPositiveAmount
                                                  ? Colors.green
                                                  : Colors.red)
                                              : Colors.blue,
                                    ).copyWith(letterSpacing: 0.1),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Divider with subtle appearance

                          // Optional: Add footer actions or icons here
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return AppColors.success;
    }
  }

  String _formatDate(String dateStr) {
    try {
      if (dateStr.isNotEmpty) {
        return timeago.format(DateTime.parse(dateStr));
      }
    } catch (e) {
      // Handle parsing error
    }
    return 'Unknown date';
  }
}

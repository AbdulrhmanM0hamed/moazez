import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:ui';

class MyRewardCard extends StatelessWidget {
  final RewardEntity reward;
  const MyRewardCard({Key? key, required this.reward}) : super(key: key);

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
                    splashColor: theme.colorScheme.primary.withValues(alpha: 0.07),
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
                                      border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3), width: 2),
                                    ),
                                    child: reward.distributedBy.avatarUrl != null && reward.distributedBy.avatarUrl!.isNotEmpty
                                        ? CustomCachedNetworkImage(
                                            imageUrl: reward.distributedBy.avatarUrl!,
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
                                        : Text(
                                            reward.distributedBy.name.isNotEmpty
                                                ? reward.distributedBy.name.substring(0, 1).toUpperCase()
                                                : '?',
                                            style: theme.textTheme.titleLarge?.copyWith(
                                              color: theme.colorScheme.onPrimaryContainer,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                                      reward.distributedBy.name,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.6,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 350),
                                      child: Text(
                                        timeago.format(DateTime.parse(reward.createdAt)),
                                        style: theme.textTheme.bodySmall?.copyWith(
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
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(reward.status, theme),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getStatusColor(reward.status, theme).withValues(alpha: 0.18),
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

                          const SizedBox(height: 16),

                          // Reward notes with improved typography
                          const SizedBox(height: 20),
                          Text(
                            reward.notes,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.7,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.94),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Amount with visual emphasis
                          Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 350),
                                padding: const EdgeInsets.all(13),
                                decoration: BoxDecoration(
                                  color:
                                      isPositiveAmount
                                          ? Colors.green.withValues(alpha: 0.15)
                                          : Colors.red.withValues(alpha: 0.16),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isPositiveAmount
                                      ? Icons.arrow_upward_rounded
                                      : Icons.arrow_downward_rounded,
                                  color:
                                      isPositiveAmount
                                          ? Colors.green
                                          : Colors.red,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'المبلغ',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${isPositiveAmount ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          color:
                                              isPositiveAmount
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.1,
                                        ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Chip(
                                avatar: Icon(
                                  Icons.task_alt,
                                  color: theme.colorScheme.secondary,
                                  size: 18,
                                ),
                                label: Text(
                                  reward.task.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                backgroundColor: theme.colorScheme.secondary
                                    .withValues(alpha: 0.13),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
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
        return theme.colorScheme.primary;
    }
  }
}

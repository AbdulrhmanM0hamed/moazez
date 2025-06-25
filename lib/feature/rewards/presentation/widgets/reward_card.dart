import 'package:flutter/material.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';

import 'package:timeago/timeago.dart' as timeago;

class RewardCard extends StatelessWidget {
  final RewardEntity reward;
  const RewardCard({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile + Avatar
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(reward.user.avatarUrl ?? ''),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reward.user.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(DateTime.parse(reward.createdAt)),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Reward Notes
            Text(
              reward.notes,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),

            const Divider(height: 24),

            // Reward Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoBlock("Amount", "\$${reward.amount}", Colors.green),
                _buildInfoBlock("Status", reward.status, Colors.blue),
              ],
            ),

            const SizedBox(height: 16),

            // Task Details + CTA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Task: ${reward.task.title}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock(String title, String data, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          data,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

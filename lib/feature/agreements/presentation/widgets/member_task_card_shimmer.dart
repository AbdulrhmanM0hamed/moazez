import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MemberTaskCardShimmer extends StatelessWidget {
  const MemberTaskCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shimmerBaseColor = theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!;
    final shimmerHighlightColor = theme.brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 200, height: 20, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 100, height: 14, color: Colors.white),
                      ],
                    ),
                  ),
                  Container(width: 24, height: 24, color: Colors.white),
                ],
              ),
              const SizedBox(height: 16),
              // Progress
              _buildShimmerInfoRow(),
              const SizedBox(height: 16),
              // Stages
              _buildShimmerInfoRow(),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              // Participant
              Row(
                children: [
                  Container(width: 50, height: 16, color: Colors.white),
                  const Spacer(),
                  const CircleAvatar(radius: 16, backgroundColor: Colors.white),
                  const SizedBox(width: 8),
                  Container(width: 80, height: 16, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerInfoRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: 60, height: 16, color: Colors.white),
            Container(width: 40, height: 16, color: Colors.white),
          ],
        ),
        const SizedBox(height: 8),
        Container(width: double.infinity, height: 8, color: Colors.white),
      ],
    );
  }
}

class ShimmerTaskList extends StatelessWidget {
  const ShimmerTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 5, // Show 5 shimmer cards
      itemBuilder: (context, index) {
        return const MemberTaskCardShimmer();
      },
    );
  }
}

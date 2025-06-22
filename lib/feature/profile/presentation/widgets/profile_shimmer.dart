import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerHeader(),
            const SizedBox(height: 24),
            _buildShimmerInfoCard(),
            const SizedBox(height: 24),
            _buildShimmerMenuItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerHeader() {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Container(
            height: 20,
            width: 150,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            height: 16,
            width: 200,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(4, (index) => _buildShimmerInfoRow()),
      ),
    );
  }

  Widget _buildShimmerInfoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerMenuItems() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: List.generate(5, (index) => _buildShimmerMenuItem()),
      ),
    );
  }

  Widget _buildShimmerMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

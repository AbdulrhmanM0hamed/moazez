import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_cubit.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_state.dart';
import 'package:moazez/feature/rewards/presentation/widgets/my_reward_card.dart';

class MyRewardsView extends StatelessWidget {
  const MyRewardsView({Key? key}) : super(key: key);
  static const String routeName = '/my-rewards';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardCubit>()..getMyRewards(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'مكافآتي'),
        body: BlocBuilder<RewardCubit, RewardState>(
          builder: (context, state) {
            if (state is RewardLoading) {
              return const Center(child: CustomProgressIndcator());
            } else if (state is RewardLoaded) {
              if (state.rewards.isEmpty) {
                return const Center(child: Text('لا توجد مكافآت حالياً'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.rewards.length,
                itemBuilder: (context, index) {
                  final reward = state.rewards[index];
                  return MyRewardCard(reward: reward);
                },
              );
            } else if (state is RewardError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('لا توجد مكافآت حالياً'));
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_cubit.dart';
import 'package:moazez/feature/rewards/presentation/cubit/reward_state.dart';
import 'package:moazez/feature/rewards/presentation/widgets/team_reward_card.dart';

class RewardsView extends StatelessWidget {
  const RewardsView({Key? key}) : super(key: key);

  static const String routeName = '/rewards';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RewardCubit>()..getTeamRewards(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'معززات الفريق'),
        body: BlocBuilder<RewardCubit, RewardState>(
          builder: (context, state) {
            if (state is RewardLoading) {
              return const Center(child: CustomProgressIndcator());
              
            } else if (state is RewardLoaded) {
              if (state.rewards.isEmpty) {
                return const Center(child: Text('لا يوجد مكافآت تابعة لفريقك'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.rewards.length,
                itemBuilder: (context, index) {
                  return TeamRewardCard(reward: state.rewards[index]);
                },
              );
            } else if (state is RewardError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('لا يوجد مكافآت تابعة لفريقك'));
            }
          },
        ),
      ),
    );
  }
}

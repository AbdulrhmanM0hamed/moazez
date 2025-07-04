import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';
import 'package:moazez/feature/profile/presentation/cubit/user_subscriptions_cubit.dart';
import 'package:moazez/feature/profile/presentation/cubit/user_subscriptions_state.dart';
import 'package:moazez/feature/profile/presentation/widgets/subscription_item_card.dart';

class SubscriptionsView extends StatelessWidget {
  static const routeName = '/subscriptions';
  const SubscriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'اشتراكاتى'),
      body: BlocBuilder<UserSubscriptionsCubit, UserSubscriptionsState>(
        builder: (context, state) {
          if (state is UserSubscriptionsError) {
            if (state.message.contains('Unauthenticated.')) {
              return const UnauthenticatedWidget();
            }
          }
          if (state is UserSubscriptionsLoading) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is UserSubscriptionsLoaded) {
            if (state.subscriptions.isEmpty) {
              return const Center(child: Text('لا يوجد اشتراكات سابقة'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder:
                  (ctx, index) => SubscriptionItemCard(
                    subscription: state.subscriptions[index],
                  ),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.subscriptions.length,
            );
          } else if (state is UserSubscriptionsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

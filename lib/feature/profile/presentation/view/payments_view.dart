import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import '../cubit/payments_cubit.dart';
import '../widgets/payment_item_card.dart';

class PaymentsView extends StatelessWidget {
  static const routeName = '/payments';
  const PaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'مدفوعاتى'),
      body: BlocBuilder<PaymentsCubit, PaymentsState>(
        builder: (context, state) {
          if (state is PaymentsLoading) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is PaymentsLoaded) {
            if (state.payments.isEmpty) {
              return const Center(child: Text('لا يوجد مدفوعات'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder:
                  (_, index) => PaymentItemCard(payment: state.payments[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.payments.length,
            );
          } else if (state is PaymentsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

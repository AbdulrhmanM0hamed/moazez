import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/profile/presentation/cubit/financial_details_cubit.dart';
import 'package:moazez/feature/profile/presentation/cubit/financial_details_state.dart';

class FinancialDetailsView extends StatelessWidget {
  const FinancialDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الدعم والمساعدة'),
      body: BlocBuilder<FinancialDetailsCubit, FinancialDetailsState>(
        builder: (context, state) {
          if (state is FinancialDetailsError) {
            if (state.message.contains('Unauthenticated.')) {
              return const UnauthenticatedWidget();
            }
          }
          if (state is FinancialDetailsLoading) {
            return const Center(child: CustomProgressIndcator());
          } else if (state is FinancialDetailsLoaded) {
            final details = state.financialDetails;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        context,
                        icon: Icons.chat_bubble_outline,
                        title: 'واتساب',
                        value: details.whatsappNumber,
                        color: Colors.green,
                        onTap: () {
                          Clipboard.setData(
                            ClipboardData(text: details.whatsappNumber),
                          );
                          CustomSnackbar.showSuccess(
                            context: context,
                            message: 'تم نسخ رقم الواتساب',
                          );
                        },
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.phone,
                        title: 'رقم الهاتف',
                        value: details.phoneNumber,
                        color: Colors.blue,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        icon: Icons.email,
                        title: 'البريد الإلكتروني',
                        value: details.email,
                        color: Colors.red,
                      ),
                      const Divider(height: 24),
                      // _buildDetailRow(
                      //   context,
                      //   icon: Icons.account_balance,
                      //   title: 'حساب بنكي',
                      //   value: details.bankAccountDetails,
                      //   color: Colors.purple,
                      // ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is FinancialDetailsError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: FontSize.size16,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: getRegularStyle(
                      color: Colors.grey[600],
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

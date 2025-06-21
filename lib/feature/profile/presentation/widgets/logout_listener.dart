import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/auth/presentation/cubit/logout_cubit/logout_cubit.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';

/// A reusable widget that listens to [LogoutCubit] states and handles UI
/// feedback such as loading indicator, success, and error snackbars.
/// Wrap the part of the UI that should be overlaid with the loading dialog.
class LogoutListener extends StatelessWidget {
  final Widget child;

  const LogoutListener({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        // Close dialog if not loading
        if (state is! LogoutLoading && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        if (state is LogoutLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CustomProgressIndcator()),
          );
        } else if (state is LogoutSuccess) {
          CustomSnackbar.showSuccess(
            context: context,
            message: 'تم تسجيل الخروج بنجاح',
          );
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                LoginView.routeName,
                (route) => false,
              );
            }
          });
        } else if (state is LogoutFailure) {
          CustomSnackbar.showError(
            context: context,
            message: state.message,
          );
        }
      },
      child: child,
    );
  }
}

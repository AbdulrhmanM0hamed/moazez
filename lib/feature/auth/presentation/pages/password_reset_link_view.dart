import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/auth/domain/usecases/send_password_reset_link_usecase.dart';
import 'package:moazez/feature/auth/presentation/cubit/password_reset/password_reset_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/password_reset/password_reset_state.dart';
import 'package:moazez/core/services/service_locator.dart';

class PasswordResetLinkView extends StatelessWidget {

  static const String routeName = '/password_reset_link_view';
  final TextEditingController emailController = TextEditingController();


  PasswordResetLinkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetCubit(sendPasswordResetLinkUseCase: sl<SendPasswordResetLinkUseCase>()),
      child: Scaffold(
        appBar: CustomAppBar(title: 'إعادة تعيين كلمة المرور'),
        body: BlocListener<PasswordResetCubit, PasswordResetState>(
          listener: (context, state) {
            if (state is PasswordResetSuccess) {
              CustomSnackbar.showSuccess(
                context: context,
                message: state.message,
              );
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
            } else if (state is PasswordResetError) {
              CustomSnackbar.showError(context: context, message: state.message);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  hint: 'البريد الإلكتروني',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                BlocBuilder<PasswordResetCubit, PasswordResetState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'إرسال الرابط',
                      onPressed: () {
                        if (emailController.text.isNotEmpty) {
                          context.read<PasswordResetCubit>().sendResetLink(
                            emailController.text,
                          );
                        } else {
                          CustomSnackbar.showError(
                            context: context,
                            message: 'يرجى إدخال بريد إلكتروني',
                          );
                        }
                      },
                      isLoading: state is PasswordResetLoading,
                      backgroundColor: AppColors.primary,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

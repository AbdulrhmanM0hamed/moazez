import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/validators/form_validators.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_state.dart';
import 'package:moazez/feature/auth/presentation/pages/signup_view.dart';
import 'package:moazez/feature/home/presentation/view/home_view.dart';

class LoginView extends StatefulWidget {
  static const String routeName = '/login';
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LoginCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'تسجيل الدخول'),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(child: const CustomProgressIndcator()),
              );
            } else if (state is LoginSuccess) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              CustomSnackbar.showSuccess(
                context: context,
                message: 'تم تسجيل الدخول بنجاح',
              );
              // الانتقال بعد نصف ثانية لإتاحة ظهور الـ Snackbar
              Future.delayed(const Duration(milliseconds: 600), () {
                Navigator.of(context).pushReplacementNamed(HomeView.routeName);
              });
            } else if (state is LoginError) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              CustomSnackbar.showError(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        prefix: const Icon(Icons.email_outlined),
                        validator: FormValidators.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        obscureText: true,
                        prefix: const Icon(Icons.lock_outline),
                        //        validator: FormValidators.validatePassword,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'دخول',
                        onPressed:
                            state is LoginLoading
                                ? null
                                : () => _onLogin(context),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ليس لديك حساب؟ ',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size16,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushReplacementNamed(RegisterView.routeName);
                            },
                            child: Text(
                              'إنشاء حساب',
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onLogin(BuildContext ctx) {
    if (_formKey.currentState?.validate() ?? false) {
      ctx.read<LoginCubit>().login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }
}

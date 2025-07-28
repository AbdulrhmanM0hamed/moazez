import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/common/password_field.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/validators/form_validators.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/feature/auth/presentation/widgets/terms_and_conditions_widget.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/auth/presentation/cubit/register/register_cubit.dart';
import 'package:moazez/feature/auth/presentation/pages/login_view.dart';
import 'package:moazez/feature/auth/presentation/pages/complete_profile_view.dart';

class SignUpView extends StatelessWidget {
  static const String routeName = '/signup';
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RegisterCubit>(),
      child: const _SignUpViewBody(),
    );
  }
}

class _SignUpViewBody extends StatefulWidget {
  const _SignUpViewBody();

  @override
  State<_SignUpViewBody> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Simple validator for optional phone field
  String? _validatePhoneOptional(String? value) {
    // Allow empty phone numbers
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    // Remove spaces and dashes
    String cleanedValue = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    // Check if it contains only numbers and + sign
    if (!RegExp(r'^[0-9+]+$').hasMatch(cleanedValue)) {
      return 'يرجى إدخال أرقام فقط';
    }
    
    // Check reasonable length (between 8 and 15 digits)
    String numbersOnly = cleanedValue.replaceAll('+', '');
    if (numbersOnly.length < 6 || numbersOnly.length > 16) {
      return 'رقم الجوال غير صحيح';
    }
    
    return null;
  }

  void _onContinue() {
    if (!_termsAccepted) {
      CustomSnackbar.showError(
        context: context,
        message: 'يجب الموافقة على الشروط والأحكام أولاً',
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Handle empty phone by providing default value since backend requires it
      String phoneValue = _phoneController.text.trim();
      if (phoneValue.isEmpty) {
        phoneValue = '0000000000'; // Default phone value for backend requirement
      }
      
      context.read<RegisterCubit>().register(
        name: _nameController.text.trim(),
        phone: phoneValue,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'إنشاء حساب'),
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CustomProgressIndcator()),
              );
            } else {
              // If not loading, and a dialog is likely open, pop it.
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              if (state is RegisterSuccess) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم تسجيل حسابك بنجاح!',
                );
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder:
                            (context) => CompleteProfileView(
                              signupData: {
                                'name': _nameController.text,
                                'email': _emailController.text,
                                'phone': _phoneController.text,
                              },
                            ),
                      ),
                      (route) => false,
                    );
                  }
                });
              } else if (state is RegisterError) {
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
                print(state.message);
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'الاسم',
                      prefix: const Icon(Icons.person_outline),
                      validator: FormValidators.validateName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneController,
                      label: 'رقم الجوال (اختياري)',
                      keyboardType: TextInputType.phone,
                      prefix: const Icon(Icons.phone_outlined),
                      validator: _validatePhoneOptional,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.email_outlined),
                      validator: FormValidators.validateEmail,
                    ),
                    const SizedBox(height: 16),

                    PasswordField(
                      controller: _passwordController,
                      hintText: 'كلمة المرور',
                      validator: FormValidators.validatePassword,
                    ),

                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _confirmPasswordController,
                      hintText: 'تأكيد كلمة المرور',
                      validator:
                          (value) => FormValidators.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                    ),
                     const SizedBox(height: 8),
                    Text(
                      'يُرجى كتابة كلمة مرور قوية تحتوي على حروف، أرقام ورموز.',
                      style: TextStyle(
                        fontSize: FontSize.size14,
                        color: Colors.grey[600],
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                   
                    const SizedBox(height: 16),
                    TermsAndConditionsWidget(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'إنشاء حساب',
                      onPressed: state is RegisterLoading ? null : _onContinue,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟ ',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(LoginView.routeName);
                          },
                          child: Text(
                            'تسجيل الدخول',
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
            );
          },
        ),
      ),
    );
  }
}

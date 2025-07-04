import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/common/password_field.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/validators/form_validators.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_cubit.dart';
import 'package:moazez/feature/auth/presentation/cubit/login/login_state.dart';
import 'package:moazez/feature/auth/presentation/pages/password_reset_link_view.dart';
import 'package:moazez/feature/auth/presentation/pages/signup_view.dart';
import 'package:moazez/feature/home_participant/presentation/view/participants_nav_bar.dart';
import 'package:flutter/services.dart';

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
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final cache = sl<CacheService>();
    bool rememberMe = await cache.getRememberMe();
    if (rememberMe) {
      final credentials = await cache.getLoginCredentials();
      if (credentials != null) {
        setState(() {
          _emailController.text = credentials['email'] ?? '';
          _passwordController.text = credentials['password'] ?? '';
          _rememberMe = true;
        });
      }
    }
  }

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
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },
        child: Scaffold(
          appBar: CustomAppBar(
            automaticallyImplyLeading: false,
            title: 'تسجيل الدخول',
          ),
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              // First, handle hiding the loading indicator if it's showing.
              // This should happen for both success and error states.
              if (state is! LoginLoading && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }

              // Now, handle the specific states
              if (state is LoginLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CustomProgressIndcator()),
                );
              } else if (state is LoginSuccess) {
                // Save credentials only if "Remember Me" is checked
                final cache = sl<CacheService>();
                if (_rememberMe) {
                  cache.setRememberMe(true);
                  cache.saveLoginCredentials(
                    _emailController.text.trim(),
                    _passwordController.text,
                  );
                } else {
                  cache.setRememberMe(false);
                  cache.clearLoginCredentials();
                }
                // Ensure default role is set to Participant if not already set
                cache.getUserRole().then((role) {
                  if (role == null) {
                    cache.saveUserRole('Participant');
                  }
                });
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم تسجيل الدخول بنجاح',
                );
                // Delay navigation to allow the snackbar to be seen
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (context.mounted) {
                    Navigator.of(
                      context,
                    ).pushReplacementNamed(ParticipantsNavBar.routeName);
                  }
                });
              } else if (state is LoginError) {
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
                        PasswordField(
                          controller: _passwordController,
                          hintText: 'كلمة المرور',
                          validator: FormValidators.validatePasswordLogin,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? true;
                                    });
                                  },
                                ),
                                Text(
                                  'تذكرني',
                                  style: getSemiBoldStyle(
                                    fontFamily: FontConstant.cairo,
                                    fontSize: FontSize.size14,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pushNamed(PasswordResetLinkView.routeName);
                              },
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size14,
                                ),
                              ),
                            ),
                          ],
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
                                ).pushNamed(SignUpView.routeName);
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
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'أو',
                                style: getMediumStyle(
                                  fontFamily: FontConstant.cairo,
                                  fontSize: FontSize.size14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'دخول كزائر',
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/guest-nav-bar');
                          },

                          icon: Icons.person_outline,

                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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

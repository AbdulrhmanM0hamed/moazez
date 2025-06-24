import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/validators/form_validators.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_cubit.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_state.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';

class SendInvitationsView extends StatefulWidget {
  const SendInvitationsView({super.key});

  @override
  State<SendInvitationsView> createState() => _SendInvitationsViewState();
}

class _SendInvitationsViewState extends State<SendInvitationsView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvitationCubit>(
      create: (context) => sl<InvitationCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'إرسال دعوة'),
        body: BlocListener<InvitationCubit, InvitationState>(
          listener: (context, state) {
            if (state is InvitationSent) {
              CustomSnackbar.show(
                context: context,
                message: 'تم إرسال الدعوة بنجاح',
              );
            } else if (state is InvitationError) {
              String errorMessage = state.message;
              if (errorMessage.contains('422')) {
                errorMessage = 'تم إرسال دعوة بالفعل لهذا البريد الإلكتروني';
              } else if (errorMessage.contains('401')) {
                errorMessage = 'خطأ في التحقق: يرجى تسجيل الدخول مرة أخرى';
              }
              CustomSnackbar.showError(context: context, message: errorMessage);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أدخل البريد الإلكتروني للمشارك',
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _emailController,
                    hint: 'البريد الإلكتروني',
                    keyboardType: TextInputType.emailAddress,
                    validator: FormValidators.validateEmail,
                    prefix: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<InvitationCubit, InvitationState>(
                    builder: (context, state) {
                      return CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<InvitationCubit>().sendInvitation(
                              _emailController.text,
                            );
                          }
                        },
                        text:
                            state is InvitationLoading
                                ? 'جاري الإرسال...'
                                : 'إرسال الدعوة',
                        isLoading: state is InvitationLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

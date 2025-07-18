import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'dart:developer' as developer;

class CreateTeamView extends StatefulWidget {
  const CreateTeamView({super.key});

  static const String routeName = '/create_team';

  @override
  State<CreateTeamView> createState() => _CreateTeamViewState();
}

class _CreateTeamViewState extends State<CreateTeamView> {
  final TextEditingController _teamNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _teamCreated = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeamCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'إنشاء فريق'),
        body: BlocListener<TeamCubit, TeamState>(
          listener: (context, state) {
            if (state is TeamError) {
              if (!_teamCreated &&
                  state.message.contains("تم إنشاء الفريق بنجاح")) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم إنشاء الفريق بنجاح',
                );
                _teamCreated = true;
                context.read<TeamCubit>().fetchTeamInfo();
                // Reduced delay to ensure quicker navigation and restart app from splash screen
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/splash',
                    (Route<dynamic> route) => false,
                  );
                });
              } else if (!_teamCreated) {
                String errorMessage = state.message;
                if (state.message.contains(
                  "البيانات المسترجعة غير صحيحة أو فارغة",
                )) {
                  errorMessage =
                      'خطأ في البيانات المُدخلة، يرجى المحاولة مرة أخرى';
                }
                CustomSnackbar.showError(
                  context: context,
                  message: errorMessage,
                );
              }
            } else if (state is TeamLoaded) {
              if (!_teamCreated) {
                developer.log('Team created successfully');
                CustomSnackbar.showSuccess(
                  context: context,
                  message: 'تم إنشاء الفريق بنجاح',
                );
                _teamCreated = true;
                context.read<TeamCubit>().fetchTeamInfo();
                // Reduced delay to ensure quicker navigation and restart app from splash screen
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/splash',
                    (Route<dynamic> route) => false,
                  );
                });
              }
            }
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إنشاء فريق جديد',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أدخل اسم الفريق لإنشائه',
                            style: getRegularStyle(
                              fontFamily: FontConstant.cairo,
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _teamNameController,
                            label: 'اسم الفريق',
                            hint: 'أدخل اسم الفريق',
                            suffix: const Icon(Icons.group),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اسم الفريق';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<TeamCubit, TeamState>(
                        builder: (context, state) {
                          return CustomButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<TeamCubit>().createTeam(
                                  _teamNameController.text,
                                );
                              }
                            },
                            text: 'إنشاء الفريق',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<TeamCubit, TeamState>(
                builder: (context, state) {
                  if (state is TeamLoading) {
                    return const Center(
                      child: CustomProgressIndcator(color: AppColors.primary),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

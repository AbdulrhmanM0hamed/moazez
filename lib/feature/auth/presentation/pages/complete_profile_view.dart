import 'package:flutter/material.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/auth/presentation/cubit/complete_profile_cubit.dart';
import 'package:moazez/feature/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:moazez/feature/auth/data/models/area_city_static.dart';
import 'package:moazez/feature/home_participant/presentation/view/participants_nav_bar.dart';

class CompleteProfileView extends StatefulWidget {
  static const String routeName = '/completeProfile';
  final Map<String, String> signupData;
  const CompleteProfileView({Key? key, required this.signupData})
    : super(key: key);

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();
  String? _gender;
  DateTime? _birthDate;
  File? _avatarImage;
  Area? _selectedArea;
  City? _selectedCity;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CompleteProfileCubit>(),
      child: BlocListener<CompleteProfileCubit, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            // Ensure default role is set to Participant if not already set
            final cache = sl<CacheService>();
            cache.getUserRole().then((role) {
              if (role == null) {
                cache.saveUserRole('Participant');
              }
            });
            Navigator.of(
              context,
            ).pushReplacementNamed(ParticipantsNavBar.routeName);
          } else if (state is CompleteProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        automaticallyImplyLeading: false,
        title: 'استكمال البيانات',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile picture
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.border,
                        backgroundImage:
                            _avatarImage != null
                                ? FileImage(_avatarImage!)
                                : null,
                        child:
                            _avatarImage == null
                                ? const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: AppColors.white,
                                )
                                : null,
                      ),
                      Positioned(
                        bottom: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primary,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Gender
                FormField<String>(
                  initialValue: _gender,
                  validator: (value) {
                    if (value == null) {
                      return 'يرجى اختيار النوع';
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'النوع',
                        errorText: state.errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // Adjust padding to make the field height similar to a TextField
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('ذكر'),
                              value: 'male',
                              groupValue: state.value,
                              onChanged: (value) {
                                setState(() {
                                  state.didChange(value);
                                  _gender = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('أنثى'),
                              value: 'female',
                              groupValue: state.value,
                              onChanged: (value) {
                                setState(() {
                                  state.didChange(value);
                                  _gender = value;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Birth date
                CustomTextField(
                  label: 'تاريخ الميلاد',
                  suffix: const Icon(Icons.calendar_today_outlined),
                  readOnly: true,
                  controller: TextEditingController(
                    text:
                        _birthDate == null
                            ? ''
                            : _birthDate!.toLocal().toString().split(' ')[0],
                  ),
                  onTap: _pickDate,
                  validator:
                      (v) =>
                          _birthDate == null
                              ? 'يرجى اختيار تاريخ الميلاد'
                              : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Area>(
                  decoration: const InputDecoration(
                    labelText: 'المنطقة',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedArea,
                  items:
                      kAreas
                          .map(
                            (a) =>
                                DropdownMenuItem(value: a, child: Text(a.name)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedArea = val;
                      _selectedCity = null;
                    });
                  },
                  validator: (v) => v == null ? 'يرجى اختيار المنطقة' : null,
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                DropdownButtonFormField<City>(
                  decoration: const InputDecoration(
                    labelText: 'المدينة',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCity,
                  items:
                      (_selectedArea?.cities ?? [])
                          .map(
                            (c) =>
                                DropdownMenuItem(value: c, child: Text(c.name)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCity = val;
                    });
                  },
                  validator: (v) => v == null ? 'يرجى اختيار المدينة' : null,
                ),
                const SizedBox(height: 32),
                BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
                  builder: (context, state) {
                    final loading = state is CompleteProfileLoading;
                    return CustomButton(
                      text: loading ? 'جارٍ الإرسال...' : 'تأكيد',
                      onPressed: loading ? null : () => _onFinish(context),
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _avatarImage = File(pickedFile.path));
      debugPrint('Picked image path: \\${pickedFile.path}');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _onFinish(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Combine data and navigate further or show success
      debugPrint(
        'Submitting CompleteProfile with avatarPath: \\${_avatarImage?.path}',
      );
      context.read<CompleteProfileCubit>().submit(
        CompleteProfileParams(
          areaId: _selectedArea!.id,
          cityId: _selectedCity!.id,
          gender: _gender!,
          birthdate: _birthDate!,
          avatarPath: _avatarImage?.path,
        ),
      );
    }
  }
}

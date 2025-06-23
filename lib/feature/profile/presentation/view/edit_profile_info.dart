import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/profile/data/models/edit_profile_params.dart';
import 'package:moazez/feature/auth/data/models/area_city_static.dart';

class EditProfileInfo extends StatefulWidget {
  static const String routeName = '/edit-profile';
  const EditProfileInfo({super.key});

  @override
  State<EditProfileInfo> createState() => _EditProfileInfoState();
}

class _EditProfileInfoState extends State<EditProfileInfo> {
  bool _isLoading = false;
  bool _isAvatarLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedGender;
  final birthdateController = TextEditingController();
  String? _selectedBirthdate;
  Area? _selectedArea;
  int? _selectedCityId;
  File? _avatarFile;

  @override
  void initState() {
    super.initState();
    birthdateController.text = _selectedBirthdate ?? '';
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    try {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        final profile = profileState.profileResponse.data.user;
        _nameController.text = profile.name ?? '';
        _emailController.text = profile.email ?? '';
        _phoneController.text = profile.phone ?? '';
        _selectedGender = profile.gender ?? '';
        birthdateController.text = profile.birthdate ?? '';

        // Find matching area and city from static data
        _selectedArea = kAreas.firstWhere(
          (area) => area.id == profile.area?.id,
          orElse: () => Area(id: 0, name: '', cities: []),
        );

        if (_selectedArea != null && profile.city != null) {
          _selectedCityId = profile.city?.id;
          // Validate if the selected city ID exists in the area's cities
          if (_selectedCityId != null && !_selectedArea!.cities.any((city) => city.id == _selectedCityId)) {
            _selectedCityId = null; // Reset if not found
          }
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _avatarFile = File(image.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await context.read<ProfileCubit>().editProfile(
          EditProfileParams(
            name: _nameController.text.isEmpty ? null : _nameController.text,
            email: _emailController.text.isEmpty ? null : _emailController.text,
            phone: _phoneController.text.isEmpty ? null : _phoneController.text,
            gender: _selectedGender,
            birthdate:
                birthdateController.text.isEmpty
                    ? null
                    : birthdateController.text,
            areaId: _selectedArea?.id.toString(),
            cityId: _selectedCityId?.toString(),
            avatarPath: _avatarFile?.path,
          ),
        );
        CustomSnackbar.show(
          context: context,
          message: 'تم تحديث الملف الشخصي بنجاح',
          isError: false,
        );
      } catch (e) {
        CustomSnackbar.show(
          context: context,
          message: 'حدث خطأ أثناء تحديث الملف الشخصي',
          isError: true,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "تعديل الملف الشخصي"),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            CustomSnackbar.show(
              context: context,
              message: state.message,
              isError: true,
            );
          }
          if (state is ProfileLoaded) {
            CustomSnackbar.show(
              context: context,
              message: 'تم تحديث الملف الشخصي بنجاح',
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child:
                                      _avatarFile != null
                                          ? Image.file(
                                            _avatarFile!,
                                            fit: BoxFit.cover,
                                          )
                                          : (state is ProfileLoaded &&
                                              state
                                                      .profileResponse
                                                      .data
                                                      .user
                                                      .avatarUrl !=
                                                  null)
                                          ? Image.network(
                                            state
                                                .profileResponse
                                                .data
                                                .user
                                                .avatarUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return const Icon(
                                                Icons.person,
                                                size: 60,
                                                color: AppColors.textSecondary,
                                              );
                                            },
                                          )
                                          : const Icon(
                                            Icons.person,
                                            size: 60,
                                            color: AppColors.textSecondary,
                                          ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha:  0.3,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child:
                                        _isAvatarLoading
                                            ? const CustomProgressIndcator(
                                              size: 20,
                                              color: Colors.white,
                                            )
                                            : const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'الاسم',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الاسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'الرجاء إدخال بريد إلكتروني صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'رقم الهاتف',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            labelText: 'النوع',
                            prefixIcon: Icon(Icons.transgender),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('ذكر')),
                            DropdownMenuItem(
                              value: 'female',
                              child: Text('أنثى'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: birthdateController,
                          decoration: const InputDecoration(
                            labelText: 'تاريخ الميلاد',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) {
                              setState(() {
                                birthdateController.text =
                                    date.toIso8601String();
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Area>(
                          value: _selectedArea,
                          decoration: InputDecoration(
                            labelText: 'المنطقة',
                            prefixIcon: const Icon(Icons.location_city),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          items:
                              kAreas
                                  .map(
                                    (area) => DropdownMenuItem(
                                      value: area,
                                      child: Text(area.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedArea = value;
                              _selectedCityId = null; // Reset city when area changes
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedCityId,
                          decoration: InputDecoration(
                            labelText: 'المدينة',
                            prefixIcon: const Icon(Icons.location_city),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          items: _selectedArea != null
                              ? _selectedArea!.cities
                                  .fold<Map<int, City>>({}, (map, city) {
                                    if (!map.containsKey(city.id)) {
                                      map[city.id] = city;
                                    }
                                    return map;
                                  })
                                  .values
                                  .map(
                                    (city) => DropdownMenuItem(
                                      value: city.id,
                                      child: Text(city.name),
                                    ),
                                  )
                                  .toList()
                              : [],
                          // Add a validator to ensure the value exists in items (for debugging)
                          validator: (value) {
                            if (_selectedArea != null && value != null) {
                              if (!_selectedArea!.cities.any((city) => city.id == value)) {
                                return 'المدينة المحددة غير موجودة في هذه المنطقة';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _selectedCityId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(16),
                              child: CustomProgressIndcator(
                                size: 40,
                                color: AppColors.primary,
                              ),
                            )
                            : CustomButton(
                              onPressed: _saveProfile,
                              text: 'حفظ التغييرات',
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    birthdateController.dispose();
    super.dispose();
  }
}

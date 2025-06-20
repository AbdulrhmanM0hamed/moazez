import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


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
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'استكمال البيانات'),
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
                        backgroundImage: _avatarImage != null
                            ? FileImage(_avatarImage!)
                            : null,
                        child: _avatarImage == null
                            ? const Icon(Icons.person, size: 48, color: AppColors.primary)
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
                            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Gender
                const Text(
                  'النوع',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('ذكر'),
                        value: 'male',
                        groupValue: _gender,
                        onChanged: (v) => setState(() => _gender = v),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('أنثى'),
                        value: 'female',
                        groupValue: _gender,
                        onChanged: (v) => setState(() => _gender = v),
                      ),
                    ),
                  ],
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
                CustomTextField(
                  controller: _cityController,
                  label: 'المدينة',
                  prefix: const Icon(Icons.location_city_outlined),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'يرجى إدخال المدينة' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _regionController,
                  label: 'المنطقة',
                  prefix: const Icon(Icons.home_work_outlined),
                  validator:
                      (v) =>
                          v == null || v.isEmpty ? 'يرجى إدخال المنطقة' : null,
                ),
                const SizedBox(height: 32),
                CustomButton(text: 'إنهاء', onPressed: _onFinish),
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

  void _onFinish() {
    if (_formKey.currentState?.validate() ?? false) {
      // Combine data and navigate further or show success
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_state.dart';

class StageCompletionDialog extends StatelessWidget {
  final int stageId;
  final String stageTitle;
  final Function(bool)? onComplete;

  const StageCompletionDialog({
    Key? key,
    required this.stageId,
    required this.stageTitle,
    this.onComplete,
  }) : super(key: key);

  bool _isValidImage(String imagePath) {
    final ext = imagePath.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(ext);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StageCompletionCubit, StageCompletionState>(
      listener: (context, state) {
        if (state is StageCompletionSuccess) {
          // Close the dialog first
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true); // Return true to indicate success
            onComplete?.call(true); // Notify parent widget
          }
          
          // Show snackbar in the parent widget
          WidgetsBinding.instance.addPostFrameCallback((_) {
            CustomSnackbar.show(
              context: context,
              message: 'تم إكمال المرحلة بنجاح',
            );
          });
        } else if (state is StageCompletionError) {
          CustomSnackbar.show(
            context: context,
            message: state.message,
            isError: true,
          );
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إكمال المرحلة: $stageTitle',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              const Text(
                'إضافة ملاحظات الإثبات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                hint: 'أدخل الملاحظات',
                maxLines: 3,
                onChanged: (value) {
                  context.read<StageCompletionCubit>().updateNotes(value);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'رفع صورة الإثبات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              BlocBuilder<StageCompletionCubit, StageCompletionState>(
                builder: (context, state) {
                  final cubit = context.read<StageCompletionCubit>();
                  
                  return Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: cubit.image != null && cubit.image!.isNotEmpty
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.file(
                                  File(cubit.image!),
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Center(
                                    child: Icon(Icons.error, color: Colors.red, size: 40),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red, size: 24),
                                  onPressed: () {
                                    cubit.updateImage('');
                                    CustomSnackbar.show(
                                      context: context,
                                      message: 'تم إلغاء الصورة',
                                    );
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                              const SizedBox(height: 8),
                              const Text(
                                'اختر صورة الإثبات',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final picker = ImagePicker();
                                        final pickedFile = await picker.pickImage(
                                          source: ImageSource.camera,
                                          imageQuality: 80,
                                          maxWidth: 1024,
                                        );
                                        if (pickedFile != null) {
                                          if (_isValidImage(pickedFile.path)) {
                                            cubit.updateImage(pickedFile.path);
                                            CustomSnackbar.show(
                                              context: context,
                                              message: 'تم اختيار الصورة بنجاح من الكاميرا',
                                            );
                                          } else {
                                            CustomSnackbar.show(
                                              context: context,
                                              message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                                              isError: true,
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        CustomSnackbar.show(
                                          context: context,
                                          message: 'فشل اختيار الصورة من الكاميرا: $e',
                                          isError: true,
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('كاميرا'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      try {
                                        final picker = ImagePicker();
                                        final pickedFile = await picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 80,
                                          maxWidth: 1024,
                                        );
                                        if (pickedFile != null) {
                                          if (_isValidImage(pickedFile.path)) {
                                            cubit.updateImage(pickedFile.path);
                                            CustomSnackbar.show(
                                              context: context,
                                              message: 'تم اختيار الصورة بنجاح من المعرض',
                                            );
                                          } else {
                                            CustomSnackbar.show(
                                              context: context,
                                              message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                                              isError: true,
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        CustomSnackbar.show(
                                          context: context,
                                          message: 'فشل اختيار الصورة من المعرض: $e',
                                          isError: true,
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('معرض'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  );
                },
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: CustomButton(
                      text: 'إكمال',
                      onPressed: () {
                        try {
                          final cubit = context.read<StageCompletionCubit>();
                          if (cubit.image != null && !cubit.image!.isEmpty) {
                            if (!_isValidImage(cubit.image!)) {
                              CustomSnackbar.show(
                                context: context,
                                message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                                isError: true,
                              );
                              return;
                            }
                          }
                          cubit.completeStage(stageId: stageId);
                          print('Attempting to complete stage with ID: $stageId');
                        } catch (e) {
                          print('Error completing stage: $e');
                          String errorMessage = 'خطأ أثناء إكمال المرحلة: $e';
                          if (e.toString().contains('422')) {
                            errorMessage = 'نوع الصورة غير مدعوم من الخادم. يرجى اختيار صورة JPG أو PNG';
                          }
                          CustomSnackbar.show(
                            context: context,
                            message: errorMessage,
                            isError: true,
                          );
                        }
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

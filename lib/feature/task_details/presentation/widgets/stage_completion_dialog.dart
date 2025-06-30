import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_state.dart';
import 'package:moazez/feature/task_details/presentation/widgets/stage_completion/stage_completion_widgets.dart';
import 'package:image_picker/image_picker.dart';

class StageCompletionDialog extends StatefulWidget {
  final int stageId;
  final String stageTitle;
  final BuildContext parentContext;
  final VoidCallback? onComplete;

  const StageCompletionDialog({
    super.key,
    required this.parentContext,
    required this.stageId,
    required this.stageTitle,
    this.onComplete,
  });

  @override
  State<StageCompletionDialog> createState() => _StageCompletionDialogState();
}

class _StageCompletionDialogState extends State<StageCompletionDialog> {
  bool _isValidImageForDialog(String imagePath) {
    final extension = imagePath.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  Future<String?> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1024,
      );
      if (pickedFile != null) {
        final imagePath = pickedFile.path;
        if (_isValidImageForDialog(imagePath)) {
          return imagePath;
        } else {
          CustomSnackbar.show(
            context: context,
            message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
            isError: true,
          );
          return null;
        }
      }
      return null;
    } catch (e) {
      CustomSnackbar.show(
        context: widget.parentContext,
        message: 'فشل اختيار الصورة: $e',
        isError: true,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StageCompletionCubit, StageCompletionState>(
      listener: (context, state) {
        if (state is StageCompletionSuccess) {
          widget.onComplete?.call();
          Navigator.of(widget.parentContext).pop(true);
          CustomSnackbar.showSuccess(
            context: widget.parentContext,
            message: 'تم إكمال المرحلة بنجاح',
          );
        } else if (state is StageCompletionError) {
          Navigator.of(context).pop(false);
          CustomSnackbar.showError(
            context: widget.parentContext,
            message: state.message,
          );
        }
      },
      child: BlocBuilder<StageCompletionCubit, StageCompletionState>(
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إكمال المرحلة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  StageCompletionTitle(title: widget.stageTitle),
                  const SizedBox(height: 20),
                  StageCompletionNotes(
                    value: context.read<StageCompletionCubit>().notes,
                    onChanged: (value) {
                      context.read<StageCompletionCubit>().updateNotes(value);
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: StageCompletionImagePicker(
                      parentContext: widget.parentContext,
                      imagePath: context.read<StageCompletionCubit>().image,
                      onImageSelected: (imagePath) {
                        context.read<StageCompletionCubit>().updateImage(
                          imagePath,
                        );
                      },
                      onImageRemoved: () {
                        context.read<StageCompletionCubit>().removeImage();
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  StageCompletionFooter(
                    onCompleted: () {
                      try {
                        final cubit = context.read<StageCompletionCubit>();
                        if (cubit.image != null && !cubit.image!.isEmpty) {
                          if (!_isValidImageForDialog(cubit.image!)) {
                            CustomSnackbar.show(
                              context: widget.parentContext,
                              message:
                                  'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                              isError: true,
                            );
                            return;
                          }
                        }
                        cubit.completeStage(stageId: widget.stageId);
                      } catch (e) {
                        print('Error completing stage: $e');
                        String errorMessage = 'خطأ أثناء إكمال المرحلة: $e';
                        if (e.toString().contains('422')) {
                          errorMessage =
                              'نوع الصورة غير مدعوم من الخادم. يرجى اختيار صورة JPG أو PNG';
                        }
                        CustomSnackbar.show(
                          context: widget.parentContext,
                          message: errorMessage,
                          isError: true,
                        );
                      }
                    },
                    onCancel: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

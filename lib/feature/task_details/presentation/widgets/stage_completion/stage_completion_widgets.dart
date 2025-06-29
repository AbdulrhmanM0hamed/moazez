import 'package:flutter/material.dart';
import 'dart:io';
import 'package:moazez/core/utils/common/custom_button.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moazez/core/widgets/custom_snackbar.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';

class StageCompletionImagePicker extends StatefulWidget {
  final VoidCallback? onImageSelected;
  final VoidCallback? onImageRemoved;
  final BuildContext parentContext;
  final String? imagePath;

  const StageCompletionImagePicker({
    Key? key,
    this.onImageSelected,
    this.onImageRemoved,
    required this.parentContext,
    this.imagePath,
  }) : super(key: key);

  @override
  State<StageCompletionImagePicker> createState() =>
      _StageCompletionImagePickerState();
}

class _StageCompletionImagePickerState
    extends State<StageCompletionImagePicker> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
  }

  @override
  void didUpdateWidget(covariant StageCompletionImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePath != oldWidget.imagePath) {
      setState(() {
        _imagePath = widget.imagePath;
      });
    }
  }

  bool _isValidImage(String imagePath) {
    final extension = imagePath.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_imagePath == null) ...[
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: IconButton(
                icon: Icon(Icons.add_a_photo, color: AppColors.primary, size: 40),
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('المعرض'),
                              onTap: () async {
                                Navigator.pop(context);
                                try {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 80,
                                    maxWidth: 1024,
                                  );
                                  if (pickedFile != null) {
                                    if (_isValidImage(pickedFile.path)) {
                                      setState(() {
                                        _imagePath = pickedFile.path;
                                      });
                                      CustomSnackbar.show(
                                        context: widget.parentContext,
                                        message: 'تم اختيار الصورة بنجاح من المعرض',
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        context: widget.parentContext,
                                        message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                                        isError: true,
                                      );
                                    }
                                  }
                                } catch (e) {
                                  CustomSnackbar.show(
                                    context: widget.parentContext,
                                    message: 'فشل اختيار الصورة من المعرض: $e',
                                    isError: true,
                                  );
                                }
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('الكاميرا'),
                              onTap: () async {
                                Navigator.pop(context);
                                try {
                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 80,
                                    maxWidth: 1024,
                                  );
                                  if (pickedFile != null) {
                                    if (_isValidImage(pickedFile.path)) {
                                      setState(() {
                                        _imagePath = pickedFile.path;
                                      });
                                      CustomSnackbar.show(
                                        context: widget.parentContext,
                                        message: 'تم اختيار الصورة بنجاح من الكاميرا',
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        context: widget.parentContext,
                                        message: 'نوع الصورة غير مدعوم. يرجى اختيار صورة JPG أو PNG',
                                        isError: true,
                                      );
                                    }
                                  }
                                } catch (e) {
                                  CustomSnackbar.show(
                                    context: widget.parentContext,
                                    message: 'فشل اختيار الصورة من الكاميرا: $e',
                                    isError: true,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                tooltip: 'إرفاق صورة لإثبات الإنجاز',
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_imagePath != null && widget.onImageRemoved != null) ...[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_imagePath!),
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomButton(
              onPressed: () {
                setState(() {
                  _imagePath = null;
                });
                widget.onImageRemoved?.call();
              },

              text: 'حذف الصورة',
              backgroundColor: Colors.red,
              textColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }
}

class StageCompletionFooter extends StatelessWidget {
  final VoidCallback? onCompleted;
  final VoidCallback? onCancel;

  const StageCompletionFooter({Key? key, this.onCompleted, this.onCancel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onCancel,
          child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: CustomButton(
            text: 'إكمال',
            onPressed: onCompleted,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

class StageCompletionNotes extends StatelessWidget {
  final String? value;
  final ValueChanged<String>? onChanged;

  const StageCompletionNotes({Key? key, this.value, this.onChanged})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: TextEditingController(text: value ?? ''),
      onChanged: onChanged,
      maxLines: 3,
      hint: 'أدخل ملاحظاتك هنا...',
    );
  }
}

class StageCompletionTitle extends StatelessWidget {
  final String title;

  const StageCompletionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'إكمال المرحلة: $title',
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

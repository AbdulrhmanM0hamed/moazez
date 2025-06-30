import 'package:flutter/material.dart';

class CancellationDialog extends StatelessWidget {
  final Function(bool) onConfirm;

  const CancellationDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.amber,
            size: 28,
          ),
          SizedBox(width: 12),
          Text(
            'إلغاء عملية الدفع',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      content: const Text(
        'هل أنت متأكد من رغبتك في إلغاء عملية الدفع؟ لن يتم اكمال عملية الاشتراك.',
        style: TextStyle(fontSize: 16, height: 1.4),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      actions: [
        SizedBox(
          width: 100,
          child: TextButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.of(context).pop(false);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'لا',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onConfirm(false);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'نعم',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

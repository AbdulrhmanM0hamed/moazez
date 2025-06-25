import 'package:flutter/material.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreements_view_body.dart';

class AgreementsView extends StatelessWidget {
  const AgreementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AgreementsViewBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task functionality to be implemented
        },
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tooltip: 'إضافة مهمة',
        child: Icon(Icons.add_task, color: Colors.white, size: 28),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyTasksView extends StatelessWidget {
  const MyTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: const Center(child: Text("مهمامى")),
    );
  }
}

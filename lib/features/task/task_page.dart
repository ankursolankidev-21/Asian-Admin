import 'package:flutter/material.dart';

import '../../core/widgets/app_text_field.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Appoint Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
        AppTextField(label: 'Task Title'),
    AppTextField(label: 'Assign To'),
    AppTextField(label: 'Description'),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {}, child: const Text('Assign Task')),
        ],
      ),
    );
  }
}

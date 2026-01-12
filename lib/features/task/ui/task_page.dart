import 'package:flutter/material.dart';

import 'add_task_sheet.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddTaskSheet(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(),
          const Divider(height: 1),
          const Expanded(
            child: _TaskListPlaceholder(),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: const Text('All'),
            selected: true,
            onSelected: (_) {},
          ),
          FilterChip(
            label: const Text('Pending'),
            selected: false,
            onSelected: (_) {},
          ),
          FilterChip(
            label: const Text('Done'),
            selected: false,
            onSelected: (_) {},
          ),
          FilterChip(
            label: const Text('Date'),
            selected: false,
            onSelected: (_) {},
          ),
          FilterChip(
            label: const Text('Area'),
            selected: false,
            onSelected: (_) {},
          ),
        ],
      ),
    );
  }
}

class _TaskListPlaceholder extends StatelessWidget {
  const _TaskListPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.assignment_outlined, size: 48),
          SizedBox(height: 8),
          Text(
            'No tasks added yet',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

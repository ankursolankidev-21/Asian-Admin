import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/task_model.dart';
import '../data/task_repository.dart';
import 'add_task_sheet.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _statusFilter = 'all'; // all / pending / completed
  String _sortFilter = 'newest'; // newest / oldest / area

  Stream<List<TaskModel>> _taskStream() {
    final repo = context.read<TaskRepository>();

    if (_statusFilter == 'all') {
      return repo.watchAllTasks();
    } else {
      return repo.watchTasksByStatus(_statusFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => const AddTaskSheet(),
              );
              // ❌ NO manual refresh needed anymore
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(
            status: _statusFilter,
            sort: _sortFilter,
            onStatusChanged: (v) {
              setState(() => _statusFilter = v);
            },
            onSortChanged: (v) {
              setState(() => _sortFilter = v);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<TaskModel>>(
              stream: _taskStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                var tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return const _EmptyView();
                }

                // 🔹 SORTING (local, safe)
                if (_sortFilter == 'oldest') {
                  tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
                } else if (_sortFilter == 'newest') {
                  tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                } else if (_sortFilter == 'area') {
                  tasks.sort((a, b) => a.area.compareTo(b.area));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return _TaskCard(task: tasks[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class _FilterBar extends StatelessWidget {
  final String status;
  final String sort;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onSortChanged;

  const _FilterBar({
    required this.status,
    required this.sort,
    required this.onStatusChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 40,
        runSpacing: 5,
        children: [
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Filter:     '),
              _chip('Newest', 'newest', sort, onSortChanged),
              _chip('Oldest', 'oldest', sort, onSortChanged),
              _chip('Area', 'area', sort, onSortChanged),
            ],
          ),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Status: '),
              _chip('All', 'all', status, onStatusChanged),
              _chip('Pending', 'pending', status, onStatusChanged),
              _chip('Done', 'completed', status, onStatusChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(
      String label,
      String value,
      String selected,
      ValueChanged<String> onChanged,
      ) {
    return ChoiceChip(
      label: Text(label),
      selected: selected == value,
      onSelected: (_) => onChanged(value),
    );
  }
}
class _TaskCard extends StatelessWidget {
  final TaskModel task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'completed';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.type,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                _StatusBadge(isDone: isDone),
              ],
            ),
            const SizedBox(height: 8),
            Text('Area: ${task.area}', style: const TextStyle(fontSize: 13)),
            Text('Address: ${task.address}',
                style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Assigned: ${task.employeeName}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  _formatDate(task.taskDate),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
class _StatusBadge extends StatelessWidget {
  final bool isDone;

  const _StatusBadge({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isDone ? 'DONE' : 'PENDING',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isDone ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.assignment_outlined, size: 48),
          SizedBox(height: 8),
          Text('No tasks found'),
        ],
      ),
    );
  }
}

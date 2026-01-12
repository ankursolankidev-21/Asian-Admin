import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_dropdown_field.dart';
import '../../employee/data/employee_repository.dart';
import '../data/task_model.dart';
import '../data/task_repository.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _areaController = TextEditingController();
  final _addressController = TextEditingController();

  String _taskType = 'Collection';

  String? _employeeId;
  String? _employeeName;

  List<Map<String, String>> _employees = [];
  bool _loadingEmployees = true;

  DateTime _taskDate = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // 🔹 LOAD ACTIVE EMPLOYEES
  Future<void> _loadEmployees() async {
    try {
      final data =
      await context.read<EmployeeRepository>().fetchActiveEmployees();
      setState(() {
        _employees = data;
        _loadingEmployees = false;
      });
    } catch (e) {
      _show('Failed to load employees');
      setState(() => _loadingEmployees = false);
    }
  }

  // 🔹 SAVE TASK TO FIREBASE
  Future<void> _saveTask() async {
    final area = _areaController.text.trim();
    final address = _addressController.text.trim();

    if (area.isEmpty ||
        address.isEmpty ||
        _employeeId == null ||
        _employeeName == null) {
      _show('Please fill all required fields');
      return;
    }

    setState(() => _saving = true);

    try {
      final task = TaskModel(
        id: '',
        type: _taskType,
        area: area,
        address: address,
        employeeId: _employeeId!,
        employeeName: _employeeName!,
        status: 'pending',
        taskDate: _taskDate,
        createdAt: DateTime.now(),
      );

      await context.read<TaskRepository>().addTask(task);

      _show('Task added successfully');
      Navigator.pop(context);
    } catch (e) {
      _show(e.toString());
    } finally {
      setState(() => _saving = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              const Text(
                'Add Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // TASK TYPE
          AppDropdownField<String>(
            label: 'Task Type',
            value: _taskType,
            showRequiredMark: true,
            items: const [
              DropdownMenuItem(value: 'Collection', child: Text('Collection')),
              DropdownMenuItem(value: 'Complaint', child: Text('Complaint')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _taskType = v!),
          ),

          const SizedBox(height: 12),

          // AREA
          AppTextField(
            label: 'Area',
            controller: _areaController,
            showRequiredMark: true,
          ),

          const SizedBox(height: 12),

          // ADDRESS
          AppTextField(
            label: 'Address',
            controller: _addressController,
            maxLines: 2,
            showRequiredMark: true,
          ),

          const SizedBox(height: 12),

          // ASSIGN EMPLOYEE
          _loadingEmployees
              ? const Center(child: CircularProgressIndicator())
              : AppDropdownField<String>(
            label: 'Assign To',
            value: _employeeId,
            showRequiredMark: true,
            items: _employees
                .map(
                  (e) => DropdownMenuItem<String>(
                value: e['id'],
                child: Text(e['name']!),
              ),
            )
                .toList(),
            onChanged: (id) {
              final emp =
              _employees.firstWhere((e) => e['id'] == id);
              setState(() {
                _employeeId = id;
                _employeeName = emp['name'];
              });
            },
          ),

          const SizedBox(height: 12),

          // DATE
          Row(
            children: [
              Expanded(
                child: Text(
                  'Date: ${_taskDate.day}/${_taskDate.month}/${_taskDate.year}',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_calendar),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _taskDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _taskDate = picked);
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ACTION BUTTONS
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveTask,
                  child: _saving
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Add Task'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/widgets/app_dropdown_field.dart';
import '../../../core/widgets/app_text_field.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  String _taskType = 'Collection';
  String? _assignedEmployee;

  final _areaController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime _taskDate = DateTime.now();

  @override
  void dispose() {
    _areaController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _taskDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _taskDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _taskDate.hour,
          _taskDate.minute,
        );
      });
    }
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
          /// HEADER
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

          /// TASK TYPE
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

          /// AREA
          AppTextField(
            controller: _areaController,
            label: 'Area',
          ),
          const SizedBox(height: 12),

          /// ADDRESS
          AppTextField(
            controller: _addressController,
            label: 'Address',
          ),

          const SizedBox(height: 12),

          /// ASSIGN EMPLOYEE (DUMMY FOR NOW)
          AppDropdownField<String>(
            label: 'Assign To',
            value: _assignedEmployee,
            showRequiredMark: true,
            items: const [
              DropdownMenuItem(value: 'emp1', child: Text('Employee 1')),
              DropdownMenuItem(value: 'emp2', child: Text('Employee 2')),
            ],
            onChanged: (v) => setState(() => _assignedEmployee = v),
          ),
          const SizedBox(height: 12),

          /// DATE & TIME
          Row(
            children: [
              Expanded(
                child: Text(
                  'Date: ${_taskDate.toString().substring(0, 16)}',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_calendar),
                onPressed: _pickDate,
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ACTION BUTTONS
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
                  onPressed: () {
                    // Firebase comes later
                  },
                  child: const Text('Add Task'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

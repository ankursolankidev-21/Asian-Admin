import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_text_field.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../data/employee_model.dart';

class EditEmployeeBottomSheet extends StatefulWidget {
  final EmployeeModel employee;

  const EditEmployeeBottomSheet({
    super.key,
    required this.employee,
  });

  @override
  State<EditEmployeeBottomSheet> createState() =>
      _EditEmployeeBottomSheetState();
}

class _EditEmployeeBottomSheetState extends State<EditEmployeeBottomSheet> {
  late final TextEditingController _nameController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _isActive = widget.employee.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateEmployee() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required')),
      );
      return;
    }

    context.read<EmployeeBloc>().add(
      UpdateEmployeeRequested(
        widget.employee.copyWith(
          name: name,
          isActive: _isActive,
        ),
      ),
    );

    Navigator.pop(context);
  }

  void _resetPassword() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Password Reset'),
        content: Text(
          'This will generate a NEW password for\n'
              '${widget.employee.name}.\n\n'
              'The old password will stop working immediately.\n\n'
              'Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // ✅ Generate password only AFTER confirmation
    final newPassword = (100000 + DateTime.now().millisecondsSinceEpoch % 900000)
        .toString();

    context.read<EmployeeBloc>().add(
      ResetEmployeePasswordRequested(
        employeeId: widget.employee.id,
        newPassword: newPassword,
      ),
    );

    // ✅ Show password ONCE
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Password Reset Successful'),
        content: Text(
          'New Password:\n\n'
              '$newPassword\n\n'
              'Share this securely with the employee.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Employee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Employee Name',
              controller: _nameController,
              showRequiredMark: true,
            ),

            const SizedBox(height: 12),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isActive,
              title: const Text('Active'),
              subtitle: const Text('Disable to block employee'),
              onChanged: (value) {
                setState(() => _isActive = value);
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateEmployee,
                    child: const Text('Update Employee'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Discard'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

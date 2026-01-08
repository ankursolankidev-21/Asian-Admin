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
  late final TextEditingController _phoneController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.name);
    _phoneController = TextEditingController(text: widget.employee.phone);
    _isActive = widget.employee.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateEmployee() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and phone are required')),
      );
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone must be exactly 10 digits')),
      );
      return;
    }

    context.read<EmployeeBloc>().add(
      UpdateEmployeeRequested(
        widget.employee.copyWith(
          name: name,
          phone: phone,
          isActive: _isActive,
        ),
      ),
    );

    // ✅ Close bottom sheet immediately
    Navigator.pop(context);
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

            AppTextField(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              showRequiredMark: true,
            ),

            const SizedBox(height: 12),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _isActive,
              title: const Text('Active'),
              subtitle: const Text('Disable to block employee'),
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),

            const SizedBox(height: 16 ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _updateEmployee,
                    child: const Text('Update Employee'),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 44,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_text_field.dart';
import '../data/employee_model.dart';
import '../data/employee_repository.dart';

class AddEmployeeBottomSheet extends StatefulWidget {
  const AddEmployeeBottomSheet({super.key});

  @override
  State<AddEmployeeBottomSheet> createState() => _AddEmployeeBottomSheetState();
}

class _AddEmployeeBottomSheetState extends State<AddEmployeeBottomSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isActive = true;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (name.isEmpty || phone.isEmpty) {
      _show('Name and phone are required');
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      _show('Phone number must be exactly 10 digits');
      return;
    }

    setState(() => _saving = true);

    try {
      await context.read<EmployeeRepository>().addEmployee(
        EmployeeModel(
          id: '',
          name: name,
          phone: phone,
          isActive: _isActive,
          createdAt: DateTime.now(),
        ),
      );

      _show('Employee added successfully');

      Navigator.pop(context); // ✅ CLOSE BOTTOM SHEET
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
        children: [
          AppTextField(
            label: 'Employee Name',
            controller: _nameController,
            showRequiredMark: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Phone Number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            showRequiredMark: true,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            value: _isActive,
            title: const Text('Active'),
            subtitle: const Text('Disable to block employee'),
            onChanged: (v) => setState(() => _isActive = v),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveEmployee,
              child: _saving
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text('Save Employee'),
            ),
          ),
        ],
      ),
    );
  }
}

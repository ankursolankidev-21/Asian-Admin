import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/app_text_field.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../data/employee_model.dart';
import '../data/employee_repository.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isActive = true;
  bool _saving = false; // ✅ LOCAL UI STATE

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
      // 🔥 CALL REPOSITORY DIRECTLY
      await context.read<EmployeeRepository>().addEmployee(
        EmployeeModel(
          id: '',
          name: name,
          phone: phone,
          isActive: _isActive,
          createdAt: DateTime.now(),
        ),
      );

      // ✅ SUCCESS ONLY IF NO ERROR
      _show('Employee added successfully');
      _nameController.clear();
      _phoneController.clear();
      setState(() => _isActive = true);
    } catch (e) {
      // ❌ DUPLICATE / VALIDATION ERROR
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
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: Center(
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
          ),
        ),
      ),
    );
  }
}

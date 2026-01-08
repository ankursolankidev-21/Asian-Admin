import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../data/employee_model.dart';
import 'edit_employee_bottom_sheet.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(WatchEmployeesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employees')),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }

          if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return const Center(child: Text('No employees found'));
            }

            return ListView.separated(
              itemCount: state.employees.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return _EmployeeTile(employee: employee);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  final EmployeeModel employee;

  const _EmployeeTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(employee.name),
      subtitle: Text(employee.phone),
      trailing: Switch(
        value: employee.isActive,
        onChanged: (value) {
          context.read<EmployeeBloc>().add(ToggleEmployeeActiveRequested(employeeId: employee.id, isActive: value));
        },
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (_) {
            return BlocProvider.value(
              value: context.read<EmployeeBloc>(),
              child: EditEmployeeBottomSheet(employee: employee),
            );
          },
        );
      },
    );
  }
}

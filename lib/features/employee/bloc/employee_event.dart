import '../data/employee_model.dart';

abstract class EmployeeEvent {}

class WatchEmployeesRequested extends EmployeeEvent {}

class AddEmployeeRequested extends EmployeeEvent {
  final EmployeeModel employee;
  AddEmployeeRequested(this.employee);
}

class ToggleEmployeeActiveRequested extends EmployeeEvent {
  final String employeeId;
  final bool isActive;

  ToggleEmployeeActiveRequested({
    required this.employeeId,
    required this.isActive,
  });
}

class UpdateEmployeeRequested extends EmployeeEvent {
  final EmployeeModel employee;

  UpdateEmployeeRequested(this.employee);
}
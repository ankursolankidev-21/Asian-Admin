import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/employee_repository.dart';
import '../data/employee_model.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc(this.repository) : super(EmployeeInitial()) {
    on<WatchEmployeesRequested>(_onWatchEmployees);
    on<AddEmployeeRequested>(_onAddEmployee);
    on<ToggleEmployeeActiveRequested>(_onToggleActive);
    on<UpdateEmployeeRequested>(_onUpdateEmployee);
    on<ResetEmployeePasswordRequested>(_onResetPassword);
  }

  /// 🔴 LIVE STREAM (NEVER COMPLETES)
  Future<void> _onWatchEmployees(
      WatchEmployeesRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    emit(EmployeeLoading());

    await emit.forEach<List<EmployeeModel>>(
      repository.watchEmployees(),
      onData: (employees) => EmployeeLoaded(employees),
      onError: (error, _) => EmployeeError(error.toString()),
    );
  }

  /// ✅ WRITE OPERATION — NO emit()
  Future<void> _onAddEmployee(
      AddEmployeeRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      await repository.addEmployee(event.employee);
      // ❌ DO NOT emit anything
      // Firestore stream will update the list
    } catch (e) {
      if (!emit.isDone) {
        emit(EmployeeError(e.toString()));
      }
    }
  }

  /// ✅ TOGGLE ACTIVE
  Future<void> _onToggleActive(
      ToggleEmployeeActiveRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      await repository.updateEmployeeActive(
        employeeId: event.employeeId,
        isActive: event.isActive,
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(EmployeeError(e.toString()));
      }
    }
  }

  /// ✅ UPDATE EMPLOYEE (NO emit)
  Future<void> _onUpdateEmployee(
      UpdateEmployeeRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      await repository.updateEmployee(event.employee);
      // ❌ DO NOT emit success
      // Firestore stream will auto-update list
    } catch (e) {
      if (!emit.isDone) {
        emit(EmployeeError(e.toString()));
      }
    }
  }

  /// 🔐 RESET PASSWORD (WRITE ONLY)
  Future<void> _onResetPassword(
      ResetEmployeePasswordRequested event,
      Emitter<EmployeeState> emit,
      ) async {
    try {
      await repository.resetPassword(
        employeeId: event.employeeId,
        newPassword: event.newPassword,
      );
      // ❌ DO NOT emit success
      // Firestore stream does not change list
    } catch (e) {
      if (!emit.isDone) {
        emit(EmployeeError(e.toString()));
      }
    }
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'employee_model.dart';

class EmployeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ---------------------------
  /// ADD EMPLOYEE
  /// ---------------------------
  Future<void> addEmployee(EmployeeModel employee) async {
    final query = await _firestore
        .collection('employees')
        .where('phone', isEqualTo: employee.phone)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      throw Exception('Phone number already exists');
    }

    await _firestore.collection('employees').add(employee.toMap());
  }

  /// ---------------------------
  /// WATCH ALL EMPLOYEES
  /// ---------------------------
  Stream<List<EmployeeModel>> watchEmployees() {
    return _firestore
        .collection('employees')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs.map(EmployeeModel.fromFirestore).toList(),
    );
  }

  /// ---------------------------
  /// UPDATE ACTIVE STATUS
  /// ---------------------------
  Future<void> updateEmployeeActive({
    required String employeeId,
    required bool isActive,
  }) async {
    await _firestore
        .collection('employees')
        .doc(employeeId)
        .update({'isActive': isActive});
  }

  /// ---------------------------
  /// UPDATE EMPLOYEE
  /// ---------------------------
  Future<void> updateEmployee(EmployeeModel employee) async {
    final query = await _firestore
        .collection('employees')
        .where('phone', isEqualTo: employee.phone)
        .get();

    for (final doc in query.docs) {
      if (doc.id != employee.id) {
        throw Exception('Phone number already exists');
      }
    }

    await _firestore
        .collection('employees')
        .doc(employee.id)
        .update(employee.toMap());
  }

  /// ---------------------------
  /// FETCH ACTIVE EMPLOYEES (FOR TASK ASSIGNMENT)
  /// ---------------------------
  Future<List<Map<String, String>>> fetchActiveEmployees() async {
    final snapshot = await _firestore
        .collection('employees')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] as String,
      };
    }).toList();
  }

  Future<void> resetPassword({
    required String employeeId,
    required String newPassword,
  }) async {
    await _firestore.collection('employees').doc(employeeId).update({
      'password': newPassword,
      'lastPasswordResetAt': Timestamp.now(),
    });
  }


}

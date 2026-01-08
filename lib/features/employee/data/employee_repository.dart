import 'package:cloud_firestore/cloud_firestore.dart';
import 'employee_model.dart';

class EmployeeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  ///--- Employee list
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


  Future<void> updateEmployeeActive({
    required String employeeId,
    required bool isActive,
  }) async {
    await _firestore
        .collection('employees')
        .doc(employeeId)
        .update({'isActive': isActive});
  }

  ///--- Update Employee
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
}

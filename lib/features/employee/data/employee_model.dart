import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String id;
  final String name;
  final String phone;
  final bool isActive;
  final DateTime createdAt;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    required this.createdAt,
  });

  /// 🔹 USED BY addEmployee() & updateEmployee()
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }

  /// 🔹 USED BY watchEmployees()
  factory EmployeeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return EmployeeModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// ✅ REQUIRED FOR EDIT (copyWith)
  EmployeeModel copyWith({
    String? id,
    String? name,
    String? phone,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

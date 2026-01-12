import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  final String id;
  final String name;
  final String phone;
  final String password;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastPasswordResetAt;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.role,
    required this.isActive,
    required this.createdAt,
    this.lastPasswordResetAt,
  });

  /// 🔹 REQUIRED BY REPOSITORY
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'password': password,
      'role': role,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastPasswordResetAt': lastPasswordResetAt != null
          ? Timestamp.fromDate(lastPasswordResetAt!)
          : null,
    };
  }

  factory EmployeeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;
    return EmployeeModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'employee',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastPasswordResetAt: data['lastPasswordResetAt'] != null
          ? (data['lastPasswordResetAt'] as Timestamp).toDate()
          : null,
    );
  }

  EmployeeModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? password,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastPasswordResetAt,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastPasswordResetAt:
      lastPasswordResetAt ?? this.lastPasswordResetAt,
    );
  }
}

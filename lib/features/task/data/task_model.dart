import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String type;
  final String area;
  final String address;
  final String employeeId;
  final String employeeName;
  final String status;
  final DateTime taskDate;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.type,
    required this.area,
    required this.address,
    required this.employeeId,
    required this.employeeName,
    required this.status,
    required this.taskDate,
    required this.createdAt,
  });

  /// FROM FIRESTORE
  factory TaskModel.fromJson(String id, Map<String, dynamic> json) {
    return TaskModel(
      id: id,
      type: json['type'] as String,
      area: json['area'] as String,
      address: json['address'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      status: json['status'] as String,
      taskDate: (json['taskDate'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  /// TO FIRESTORE
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'area': area,
      'address': address,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'status': status,
      'taskDate': Timestamp.fromDate(taskDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

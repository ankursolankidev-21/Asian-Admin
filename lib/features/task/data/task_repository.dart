import 'package:cloud_firestore/cloud_firestore.dart';

import 'task_model.dart';

class TaskRepository {
  final _db = FirebaseFirestore.instance;

  /// ADD TASK
  Future<void> addTask(TaskModel task) async {
    await _db.collection('tasks').add(task.toJson());
  }

  /// FETCH ALL TASKS (latest first)
  Future<List<TaskModel>> fetchTasks() async {
    final snapshot = await _db
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  /// FETCH TASKS BY STATUS (pending / done)
  Future<List<TaskModel>> fetchTasksByStatus(String status) async {
    final snapshot = await _db
        .collection('tasks')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TaskModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}

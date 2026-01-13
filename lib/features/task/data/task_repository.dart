import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_model.dart';

class TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task) async {
    await _db.collection('tasks').add(task.toJson());
  }

  Stream<List<TaskModel>> watchAllTasks() {
    return _db
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.id, doc.data()))
          .toList(),
    );
  }

  Stream<List<TaskModel>> watchTasksByStatus(String status) {
    return _db
        .collection('tasks')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    await _db.collection('tasks').doc(taskId).update({
      'status': status,
      if (status == 'completed') 'completedAt': Timestamp.now(),
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _db.collection('tasks').doc(taskId).delete();
  }
}

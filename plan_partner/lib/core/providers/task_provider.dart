import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final _uuid = const Uuid();

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    Duration? estimatedDuration,
  }) {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      estimatedDuration: estimatedDuration,
    );
    _tasks.add(task);
    notifyListeners();
  }

  Task? getById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  void toggleComplete(String id) {
    final t = getById(id);
    if (t != null) {
      t.isCompleted = !t.isCompleted;
      notifyListeners();
    }
  }
}

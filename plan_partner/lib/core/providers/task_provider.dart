import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final _uuid = const Uuid();
  final FirebaseFirestore? _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  TaskProvider() {
    _listenToFirestore();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> _listenToFirestore() async {
    try {
      _sub = _firestore!.collection('tasks').snapshots().listen((snap) {
        _tasks.clear();
        for (final doc in snap.docs) {
          try {
            final t = Task.fromJson(doc.data());
            _tasks.add(t);
          } catch (_) {}
        }
        notifyListeners();
      });
    } catch (_) {
      // If Firestore isn't configured, keep using in-memory list
    }
  }

  Future<void> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    Duration? estimatedDuration,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      estimatedDuration: estimatedDuration,
    );

    // Try writing to Firestore; if unavailable, fall back to in-memory
    try {
      await _firestore!.collection('tasks').doc(task.id).set(task.toJson());
    } catch (_) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  Task? getById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> toggleComplete(String id) async {
    final t = getById(id);
    if (t != null) {
      t.isCompleted = !t.isCompleted;
      // persist change
      try {
        await _firestore!.collection('tasks').doc(t.id).update({
          'isCompleted': t.isCompleted,
        });
      } catch (_) {
        notifyListeners();
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

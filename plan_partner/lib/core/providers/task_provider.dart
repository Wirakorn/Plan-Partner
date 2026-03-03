import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  final _uuid = const Uuid();
  static const String _localTasksKey = 'plan_partner_tasks';
  FirebaseFirestore? _firestore;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  TaskProvider() {
    _initialize();
  }

  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> _initialize() async {
    try {
      _firestore = FirebaseFirestore.instance;
      await _listenToFirestore();
    } catch (_) {
      _firestore = null;
      await _loadLocalTasks();
    }
  }

  Future<void> _listenToFirestore() async {
    final firestore = _firestore;
    if (firestore == null) return;
    try {
      _sub = firestore.collection('tasks').snapshots().listen((snap) {
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
      _firestore = null;
      await _loadLocalTasks();
    }
  }

  Future<void> _loadLocalTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_localTasksKey);
      if (raw == null || raw.isEmpty) return;

      final decoded = jsonDecode(raw);
      if (decoded is! List) return;

      _tasks.clear();
      for (final item in decoded) {
        try {
          final jsonMap = (item as Map).cast<String, dynamic>();
          _tasks.add(Task.fromJson(jsonMap));
        } catch (_) {}
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveLocalTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = jsonEncode(_tasks.map((task) => task.toJson()).toList());
      await prefs.setString(_localTasksKey, payload);
    } catch (_) {}
  }

  Future<void> addTask({
    required String title,
    String? description,
    DateTime? dueDate,
    Duration? estimatedDuration,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      estimatedDuration: estimatedDuration,
      priority: priority,
    );

    // Try writing to Firestore; if unavailable, fall back to in-memory
    try {
      if (_firestore == null) throw Exception('Firestore not initialized');
      await _firestore!.collection('tasks').doc(task.id).set(task.toJson());
    } catch (_) {
      _tasks.add(task);
      await _saveLocalTasks();
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

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    DateTime? dueDate,
    Duration? estimatedDuration,
    TaskPriority priority = TaskPriority.medium,
  }) async {
    final existing = getById(id);
    if (existing == null) return;

    existing.title = title;
    existing.description = description;
    existing.dueDate = dueDate;
    existing.estimatedDuration = estimatedDuration;
    existing.priority = priority;

    try {
      if (_firestore == null) throw Exception('Firestore not initialized');
      await _firestore!.collection('tasks').doc(existing.id).update({
        'title': existing.title,
        'description': existing.description,
        'dueDate': existing.dueDate?.toIso8601String(),
        'estimatedDuration': existing.estimatedDuration?.inMinutes,
        'priority': taskPriorityToString(existing.priority),
      });
    } catch (_) {
      await _saveLocalTasks();
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> toggleComplete(String id) async {
    final t = getById(id);
    if (t != null) {
      t.isCompleted = !t.isCompleted;
      // persist change
      try {
        if (_firestore == null) throw Exception('Firestore not initialized');
        await _firestore!.collection('tasks').doc(t.id).update({
          'isCompleted': t.isCompleted,
        });
      } catch (_) {
        await _saveLocalTasks();
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

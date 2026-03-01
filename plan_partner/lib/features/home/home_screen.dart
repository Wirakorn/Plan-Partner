import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task.dart';
import '../../core/providers/task_provider.dart';
import '../../widgets/task_list.dart';
import 'package:go_router/go_router.dart';

/// A container screen that hosts three tabs with live task data from [TaskProvider].
///
/// Uses [DefaultTabController] to manage the selected tab. Each tab is
/// backed by a [TaskList] widget which renders tasks filtered by state.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Get today's incomplete tasks (tasks due today with no completion date)
  static List<Task> _filterToday(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return false;
      final dueOnly = DateTime(
        t.dueDate!.year,
        t.dueDate!.month,
        t.dueDate!.day,
      );
      return dueOnly == today;
    }).toList();
  }

  /// Get upcoming incomplete tasks (tasks due in the future)
  static List<Task> _filterUpcoming(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasks.where((t) {
      if (t.isCompleted) return false;
      if (t.dueDate == null) return false;
      final dueOnly = DateTime(
        t.dueDate!.year,
        t.dueDate!.month,
        t.dueDate!.day,
      );
      return dueOnly.isAfter(today);
    }).toList();
  }

  /// Get all completed tasks
  static List<Task> _filterCompleted(List<Task> tasks) {
    return tasks.where((t) => t.isCompleted).toList();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plan Partner'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskList(
              tasks: _filterToday(tasks),
              onComplete: (taskId) => taskProvider.toggleComplete(taskId),
            ),
            TaskList(
              tasks: _filterUpcoming(tasks),
              onComplete: (taskId) => taskProvider.toggleComplete(taskId),
            ),
            TaskList(
              tasks: _filterCompleted(tasks),
              onComplete: (taskId) => taskProvider.toggleComplete(taskId),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/entry'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

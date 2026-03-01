import 'package:flutter/material.dart';
import '../core/models/task.dart';
import 'task_card.dart';

/// Displays a scrollable list of [TaskCard]s. If the list is empty a
/// friendly placeholder is shown instead.
///
/// The [onComplete] callback is invoked when a task's complete button is tapped.
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(String)? onComplete;
  const TaskList({required this.tasks, this.onComplete, super.key});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks to display'));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) =>
          TaskCard(task: tasks[index], onComplete: onComplete),
    );
  }
}

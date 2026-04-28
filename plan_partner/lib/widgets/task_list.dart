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
  final Function(String)? onEdit;
  final Function(String)? onDelete;
  const TaskList({
    required this.tasks,
    this.onComplete,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 42,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No tasks to display',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Add a task to get started.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskCard(
        task: tasks[index],
        onComplete: onComplete,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/models/task.dart';

String _priorityLabel(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return 'High';
    case TaskPriority.medium:
      return 'Medium';
    case TaskPriority.low:
      return 'Low';
  }
}

Color _priorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return Colors.red;
    case TaskPriority.medium:
      return Colors.orange;
    case TaskPriority.low:
      return Colors.green;
  }
}

/// A simple card used to display a task's basic information.
///
/// The layout is deliberately lightweight and uses [Expanded] to prevent
/// overflow on narrow screens. Text fields wrap if they are too long.
///
/// Tapping the completion icon calls [onComplete] with the task's ID.
class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String)? onComplete;
  final Function(String)? onEdit;
  const TaskCard({required this.task, this.onComplete, this.onEdit, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text('Priority: ${_priorityLabel(task.priority)}'),
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      side: BorderSide(color: _priorityColor(task.priority)),
                    ),
                  ),
                  if (task.dueDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Due: ${task.dueDate}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  if (task.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        task.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit task',
                  onPressed: () => onEdit?.call(task.id),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  tooltip: task.isCompleted
                      ? 'Mark as incomplete'
                      : 'Mark as complete',
                  onPressed: () => onComplete?.call(task.id),
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

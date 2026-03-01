import 'package:flutter/material.dart';
import '../core/models/task.dart';

/// A simple card used to display a task's basic information.
///
/// The layout is deliberately lightweight and uses [Expanded] to prevent
/// overflow on narrow screens. Text fields wrap if they are too long.
///
/// Tapping the completion icon calls [onComplete] with the task's ID.
class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String)? onComplete;
  const TaskCard({required this.task, this.onComplete, super.key});

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
            GestureDetector(
              onTap: () => onComplete?.call(task.id),
              child: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

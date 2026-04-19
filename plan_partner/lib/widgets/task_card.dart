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
  final Function(String)? onDelete;
  const TaskCard({
    required this.task,
    this.onComplete,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  String _formatDueDate() {
    final due = task.dueDate;
    if (due == null) return 'No due date';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueOnly = DateTime(due.year, due.month, due.day);
    final difference = dueOnly.difference(today).inDays;

    if (difference == 0) return 'Due today';
    if (difference == 1) return 'Due tomorrow';
    if (difference > 1) return 'Due in $difference days';
    return 'Overdue';
  }

  Color _statusColor(BuildContext context) {
    if (task.isCompleted) return const Color(0xFF2C9C6B);
    if (task.priority == TaskPriority.high) return const Color(0xFFE85D5D);
    if (task.priority == TaskPriority.medium) return const Color(0xFFF0A23B);
    return const Color(0xFF4DB8A8);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, statusColor.withValues(alpha: 0.03)],
          ),
          border: Border(left: BorderSide(color: statusColor, width: 5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (task.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F7EE),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Done',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: const Color(0xFF2C9C6B),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MiniTag(
                          icon: Icons.flag_rounded,
                          label: _priorityLabel(task.priority),
                          color: _priorityColor(task.priority),
                        ),
                        _MiniTag(
                          icon: Icons.schedule_rounded,
                          label: _formatDueDate(),
                          color: statusColor,
                        ),
                      ],
                    ),
                    if (task.description != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    tooltip: 'Delete task',
                    onPressed: () => onDelete?.call(task.id),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFDECEC),
                    ),
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFD64B4B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton.filledTonal(
                    tooltip: 'Edit task',
                    onPressed: () => onEdit?.call(task.id),
                    icon: const Icon(Icons.edit_rounded),
                  ),
                  const SizedBox(height: 8),
                  IconButton.filled(
                    tooltip: task.isCompleted
                        ? 'Mark as incomplete'
                        : 'Mark as complete',
                    onPressed: () => onComplete?.call(task.id),
                    style: IconButton.styleFrom(
                      backgroundColor: task.isCompleted
                          ? const Color(0xFFE8F7EE)
                          : const Color(0xFFEAF8F5),
                    ),
                    icon: Icon(
                      task.isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      color: task.isCompleted
                          ? const Color(0xFF2C9C6B)
                          : const Color(0xFF24796E),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MiniTag({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

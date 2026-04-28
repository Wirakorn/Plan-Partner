import 'package:flutter/material.dart';
import '../../widgets/brand_app_icon.dart';
import 'package:provider/provider.dart';
import '../../core/providers/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final String id;
  const TaskDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TaskProvider>().getById(id);
    if (task == null) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: const [
              BrandAppIcon(size: 28, elevated: false),
              SizedBox(width: 10),
              Text('Task'),
            ],
          ),
        ),
        body: const Center(child: Text('Not found')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const BrandAppIcon(size: 28, elevated: false),
            const SizedBox(width: 10),
            Expanded(child: Text(task.title)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                if (task.description != null)
                  Text(
                    task.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBFA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text('Due: ${task.dueDate ?? '—'}'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    context.read<TaskProvider>().toggleComplete(task.id);
                  },
                  icon: Icon(
                    task.isCompleted ? Icons.undo_rounded : Icons.check_rounded,
                  ),
                  label: Text(
                    task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

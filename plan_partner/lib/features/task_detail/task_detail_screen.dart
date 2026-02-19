import 'package:flutter/material.dart';
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
        appBar: AppBar(title: const Text('Task')),
        body: const Center(child: Text('Not found')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null) Text(task.description!),
            const SizedBox(height: 16),
            Text('Due: ${task.dueDate ?? '—'}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<TaskProvider>().toggleComplete(task.id);
              },
              child: Text(
                task.isCompleted ? 'Mark Incomplete' : 'Mark Complete',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

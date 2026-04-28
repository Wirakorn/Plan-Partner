import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/task_provider.dart';
import '../../core/models/task.dart';
import 'package:go_router/go_router.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TaskProvider>().tasks;
    return Scaffold(
      appBar: AppBar(title: const Text('Plan Partner — Today')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, i) {
          final Task t = tasks[i];
          return ListTile(
            title: Text(t.title),
            subtitle: t.dueDate != null ? Text('${t.dueDate}') : null,
            trailing: Checkbox(
              value: t.isCompleted,
              onChanged: (_) =>
                  context.read<TaskProvider>().toggleComplete(t.id),
            ),
            onTap: () => context.push('/detail/${t.id}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/entry'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

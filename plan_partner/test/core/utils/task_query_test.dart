import 'package:flutter_test/flutter_test.dart';

import 'package:plan_partner/core/models/task.dart';
import 'package:plan_partner/core/utils/task_query.dart';

void main() {
  test('searchTasks matches title and description', () {
    final tasks = [
      Task(id: '1', title: 'Buy milk', description: 'For breakfast'),
      Task(id: '2', title: 'Study math', description: 'Linear algebra'),
    ];

    final result = searchTasks(tasks, 'break');

    expect(result, hasLength(1));
    expect(result.first.id, '1');
  });

  test('sortTasksByPriorityAndDueDate puts high priority first', () {
    final tasks = [
      Task(id: '1', title: 'Low', priority: TaskPriority.low),
      Task(id: '2', title: 'High', priority: TaskPriority.high),
      Task(id: '3', title: 'Medium', priority: TaskPriority.medium),
    ];

    final result = sortTasksByPriorityAndDueDate(tasks);

    expect(result.map((task) => task.id), ['2', '3', '1']);
  });
}

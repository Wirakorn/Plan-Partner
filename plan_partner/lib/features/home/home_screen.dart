import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/task.dart';
import '../../core/providers/task_provider.dart';
import '../../widgets/task_list.dart';
import 'package:go_router/go_router.dart';

class _MockWeather {
  final String label;
  final String condition;
  final int tempC;

  const _MockWeather({
    required this.label,
    required this.condition,
    required this.tempC,
  });
}

/// A container screen that hosts three tabs with live task data from [TaskProvider].
///
/// Uses [DefaultTabController] to manage the selected tab. Each tab is
/// backed by a [TaskList] widget which renders tasks filtered by state.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<_MockWeather> _weatherData = [
    _MockWeather(label: 'Now', condition: 'Cloudy', tempC: 30),
    _MockWeather(label: '14:00', condition: 'Light Rain', tempC: 29),
    _MockWeather(label: '18:00', condition: 'Partly Cloudy', tempC: 28),
  ];

  static void _showWeatherPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 24,
          ),
          title: const Text('Weather'),
          content: SizedBox(
            width: 280,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _weatherData
                  .map(
                    (w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.cloud_outlined, size: 18),
                          const SizedBox(width: 8),
                          Expanded(child: Text('${w.label} • ${w.condition}')),
                          Text('${w.tempC}°C'),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static List<Task> _sortByPriority(List<Task> tasks) {
    final sorted = [...tasks];
    sorted.sort((a, b) {
      final byPriority = taskPriorityRank(
        b.priority,
      ).compareTo(taskPriorityRank(a.priority));
      if (byPriority != 0) return byPriority;
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });
    return sorted;
  }

  /// Get today's incomplete tasks (tasks due today with no completion date)
  static List<Task> _filterToday(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _sortByPriority(
      tasks.where((t) {
        if (t.isCompleted) return false;
        if (t.dueDate == null) return false;
        final dueOnly = DateTime(
          t.dueDate!.year,
          t.dueDate!.month,
          t.dueDate!.day,
        );
        return dueOnly == today;
      }).toList(),
    );
  }

  /// Get upcoming incomplete tasks (tasks due in the future)
  static List<Task> _filterUpcoming(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _sortByPriority(
      tasks.where((t) {
        if (t.isCompleted) return false;
        if (t.dueDate == null) return false;
        final dueOnly = DateTime(
          t.dueDate!.year,
          t.dueDate!.month,
          t.dueDate!.day,
        );
        return dueOnly.isAfter(today);
      }).toList(),
    );
  }

  /// Get all completed tasks
  static List<Task> _filterCompleted(List<Task> tasks) {
    return _sortByPriority(tasks.where((t) => t.isCompleted).toList());
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;
    String? renderError;

    List<Task> todayTasks = const [];
    List<Task> upcomingTasks = const [];
    List<Task> completedTasks = const [];

    try {
      todayTasks = _filterToday(tasks);
      upcomingTasks = _filterUpcoming(tasks);
      completedTasks = _filterCompleted(tasks);
    } catch (error, stackTrace) {
      renderError = error.toString();
      debugPrint('HomeScreen render error: $error');
      debugPrint('$stackTrace');
    }

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
        body: renderError == null
            ? TabBarView(
                children: [
                  TaskList(
                    tasks: todayTasks,
                    onComplete: (taskId) => taskProvider.toggleComplete(taskId),
                    onEdit: (taskId) => context.push('/entry/$taskId'),
                  ),
                  TaskList(
                    tasks: upcomingTasks,
                    onComplete: (taskId) => taskProvider.toggleComplete(taskId),
                    onEdit: (taskId) => context.push('/entry/$taskId'),
                  ),
                  TaskList(
                    tasks: completedTasks,
                    onComplete: (taskId) => taskProvider.toggleComplete(taskId),
                    onEdit: (taskId) => context.push('/entry/$taskId'),
                  ),
                ],
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Home failed to render: $renderError',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              heroTag: 'weatherFab',
              onPressed: () => _showWeatherPopup(context),
              child: const Icon(Icons.cloud_outlined),
            ),
            const SizedBox(width: 12),
            FloatingActionButton(
              heroTag: 'addTaskFab',
              onPressed: () => context.push('/entry'),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

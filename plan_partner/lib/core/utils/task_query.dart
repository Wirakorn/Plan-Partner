import '../models/task.dart';

List<Task> sortTasksByPriorityAndDueDate(List<Task> tasks) {
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

List<Task> searchTasks(List<Task> tasks, String query) {
  final normalized = query.trim().toLowerCase();
  if (normalized.isEmpty) return [...tasks];

  return tasks.where((task) {
    final title = task.title.toLowerCase();
    final description = task.description?.toLowerCase() ?? '';
    return title.contains(normalized) || description.contains(normalized);
  }).toList();
}

List<Task> filterTodayTasks(List<Task> tasks) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return sortTasksByPriorityAndDueDate(
    tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      final dueOnly = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      return dueOnly == today;
    }).toList(),
  );
}

List<Task> filterUpcomingTasks(List<Task> tasks) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return sortTasksByPriorityAndDueDate(
    tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      final dueOnly = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      return dueOnly.isAfter(today);
    }).toList(),
  );
}

List<Task> filterCompletedTasks(List<Task> tasks) {
  return sortTasksByPriorityAndDueDate(
    tasks.where((task) => task.isCompleted).toList(),
  );
}

List<Task> tasksDueSoon(
  List<Task> tasks, {
  Duration threshold = const Duration(hours: 24),
}) {
  final now = DateTime.now();
  final cutoff = now.add(threshold);
  return sortTasksByPriorityAndDueDate(
    tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(now) && task.dueDate!.isBefore(cutoff);
    }).toList(),
  );
}

enum TaskPriority { high, medium, low }

TaskPriority taskPriorityFromString(String? value) {
  switch (value) {
    case 'high':
      return TaskPriority.high;
    case 'low':
      return TaskPriority.low;
    case 'medium':
    default:
      return TaskPriority.medium;
  }
}

String taskPriorityToString(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return 'high';
    case TaskPriority.medium:
      return 'medium';
    case TaskPriority.low:
      return 'low';
  }
}

int taskPriorityRank(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return 3;
    case TaskPriority.medium:
      return 2;
    case TaskPriority.low:
      return 1;
  }
}

class Task {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  Duration? estimatedDuration;
  TaskPriority priority;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.estimatedDuration,
    this.priority = TaskPriority.medium,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final title = json['title'] as String?;

    if (id == null || id.isEmpty || title == null || title.isEmpty) {
      throw FormatException('Task requires id and title fields');
    }

    return Task(
      id: id,
      title: title,
      description: json['description'] as String?,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.tryParse(json['dueDate'] as String? ?? ''),
      estimatedDuration: json['estimatedDuration'] == null
          ? null
          : Duration(
              minutes: (json['estimatedDuration'] as num?)?.toInt() ?? 0,
            ),
      priority: taskPriorityFromString(json['priority'] as String?),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'estimatedDuration': estimatedDuration?.inMinutes,
    'priority': taskPriorityToString(priority),
    'isCompleted': isCompleted,
  };
}

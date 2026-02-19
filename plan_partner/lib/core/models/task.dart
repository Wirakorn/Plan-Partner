class Task {
  final String id;
  String title;
  String? description;
  DateTime? dueDate;
  Duration? estimatedDuration;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.dueDate,
    this.estimatedDuration,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String?,
    dueDate: json['dueDate'] == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    estimatedDuration: json['estimatedDuration'] == null
        ? null
        : Duration(minutes: json['estimatedDuration'] as int),
    isCompleted: json['isCompleted'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'estimatedDuration': estimatedDuration?.inMinutes,
    'isCompleted': isCompleted,
  };
}

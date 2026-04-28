import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/models/task.dart';
import '../../core/providers/task_provider.dart';

/// Formats a DateTime into a readable date string.
String _formatDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));
  final dateOnly = DateTime(date.year, date.month, date.day);

  if (dateOnly == today) {
    return 'Today';
  } else if (dateOnly == tomorrow) {
    return 'Tomorrow';
  } else {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}

/// Utility that shows a date picker and returns the chosen [DateTime] or null.
/// Does not allow selecting dates in the past.
Future<DateTime?> _pickDate(BuildContext context, DateTime? initial) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final picked = await showDatePicker(
    context: context,
    initialDate: initial ?? now,
    firstDate: today,
    lastDate: DateTime(now.year + 5),
  );
  if (picked != null && picked.isBefore(today)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot select dates in the past')),
      );
    }
    return null;
  }
  return picked;
}

Future<TimeOfDay?> _pickTime(BuildContext context, TimeOfDay? initial) async {
  return showTimePicker(
    context: context,
    initialTime: initial ?? TimeOfDay.now(),
  );
}

class TaskEntryScreen extends StatefulWidget {
  final String? taskId;
  const TaskEntryScreen({this.taskId, super.key});

  @override
  State<TaskEntryScreen> createState() => _TaskEntryScreenState();
}

class _TaskEntryScreenState extends State<TaskEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  int _estimatedMinutes = 30; // default 30 minutes
  TaskPriority _priority = TaskPriority.medium;
  bool _loadedExisting = false;

  bool get _isEditMode => widget.taskId != null;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditMode && !_loadedExisting) {
      final task = context.read<TaskProvider>().getById(widget.taskId!);
      if (task != null) {
        _loadFromTask(task);
      }
      _loadedExisting = true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Task' : 'New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final date = await _pickDate(context, _dueDate);
                        if (date != null) {
                          setState(() {
                            _dueDate = date;
                          });
                        }
                      },
                      child: Text(
                        _dueDate == null
                            ? 'Pick due date'
                            : 'Date: ${_formatDate(_dueDate!)}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final time = await _pickTime(context, _dueTime);
                        if (time != null) {
                          setState(() {
                            _dueTime = time;
                          });
                        }
                      },
                      child: Text(
                        _dueTime == null
                            ? 'Pick due time'
                            : 'Time: ${_dueTime!.format(context)}',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: _estimatedMinutes,
                decoration: const InputDecoration(
                  labelText: 'Estimated Duration',
                  hintText: 'How long will this task take?',
                ),
                items: const [
                  DropdownMenuItem(value: 15, child: Text('15 minutes')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes')),
                  DropdownMenuItem(value: 45, child: Text('45 minutes')),
                  DropdownMenuItem(value: 60, child: Text('1 hour')),
                  DropdownMenuItem(value: 90, child: Text('1.5 hours')),
                  DropdownMenuItem(value: 120, child: Text('2 hours')),
                  DropdownMenuItem(value: 180, child: Text('3 hours')),
                  DropdownMenuItem(value: 240, child: Text('4 hours')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _estimatedMinutes = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                initialValue: _priority,
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  hintText: 'Select task priority',
                ),
                items: const [
                  DropdownMenuItem(
                    value: TaskPriority.high,
                    child: Text('High'),
                  ),
                  DropdownMenuItem(
                    value: TaskPriority.medium,
                    child: Text('Medium'),
                  ),
                  DropdownMenuItem(value: TaskPriority.low, child: Text('Low')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (!_isEditMode && _dueTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select due time before saving'),
                        ),
                      );
                      return;
                    }

                    DateTime? due;
                    if (_dueTime != null) {
                      final dt = _dueDate ?? DateTime.now();
                      due = DateTime(
                        dt.year,
                        dt.month,
                        dt.day,
                        _dueTime!.hour,
                        _dueTime!.minute,
                      );
                    } else if (_dueDate != null) {
                      due = _dueDate;
                    }
                    if (_isEditMode) {
                      context.read<TaskProvider>().updateTask(
                        id: widget.taskId!,
                        title: _titleCtrl.text,
                        description: _descCtrl.text.isEmpty
                            ? null
                            : _descCtrl.text,
                        dueDate: due,
                        estimatedDuration: Duration(minutes: _estimatedMinutes),
                        priority: _priority,
                      );
                    } else {
                      context.read<TaskProvider>().addTask(
                        title: _titleCtrl.text,
                        description: _descCtrl.text.isEmpty
                            ? null
                            : _descCtrl.text,
                        dueDate: due,
                        estimatedDuration: Duration(minutes: _estimatedMinutes),
                        priority: _priority,
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(_isEditMode ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadFromTask(Task task) {
    _titleCtrl.text = task.title;
    _descCtrl.text = task.description ?? '';
    _dueDate = task.dueDate;
    if (task.dueDate != null) {
      _dueTime = TimeOfDay(
        hour: task.dueDate!.hour,
        minute: task.dueDate!.minute,
      );
    }
    _estimatedMinutes = task.estimatedDuration?.inMinutes ?? 30;
    _priority = task.priority;
  }
}

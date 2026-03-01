import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
  const TaskEntryScreen({super.key});

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

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DateTime? due;
                    if (_dueDate != null) {
                      final dt = _dueDate!;
                      if (_dueTime != null) {
                        due = DateTime(
                          dt.year,
                          dt.month,
                          dt.day,
                          _dueTime!.hour,
                          _dueTime!.minute,
                        );
                      } else {
                        due = dt;
                      }
                    }
                    context.read<TaskProvider>().addTask(
                      title: _titleCtrl.text,
                      description: _descCtrl.text.isEmpty
                          ? null
                          : _descCtrl.text,
                      dueDate: due,
                      estimatedDuration: Duration(minutes: _estimatedMinutes),
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

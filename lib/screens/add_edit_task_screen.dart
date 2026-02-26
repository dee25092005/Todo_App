import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
import 'package:todoo_app/services/notification.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class AddEditTaskScreen extends ConsumerStatefulWidget {
  final Task? task; // Optional task for editing
  const AddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends ConsumerState<AddEditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now(); // Default to today
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // If editing an existing task, pre-fill fields
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDueDate = widget.task!.dueDate;
      _isCompleted = widget.task!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    // 1. Calculate the "Minimum" safe time (5 minutes from now)
    final now = DateTime.now();
    final fiveMinutesAhead = now.add(const Duration(minutes: 5));

    // 2. Pick the Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate.isBefore(now)
          ? fiveMinutesAhead
          : _selectedDueDate,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // 3. Pick the Time (Default to 5 mins ahead)
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fiveMinutesAhead),
      );

      if (pickedTime != null) {
        final newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // 4. Force 5-minute buffer
        if (newDateTime.isBefore(fiveMinutesAhead)) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ Setting to 5 mins ahead to ensure notification fires!',
              ),
              backgroundColor: Colors.orangeAccent,
            ),
          );
          setState(() {
            _selectedDueDate = fiveMinutesAhead;
          });
        } else {
          setState(() {
            _selectedDueDate = newDateTime;
          });
        }
      }
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final tasksNotifier = ref.read(tasksProvider.notifier);

      // Create the task object
      final taskToSave =
          widget.task?.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: _selectedDueDate,
            updatedAt: DateTime.now(),
          ) ??
          Task(
            id: const Uuid().v4(),
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            dueDate: _selectedDueDate,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

      // One single await for everything
      if (widget.task == null) {
        await tasksNotifier.addTask(taskToSave);
      } else {
        await tasksNotifier.updateTask(taskToSave);
      }

      if (!mounted) return;
      Navigator.of(
        context,
      ).pop(); // Now this will only run after everything is done
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add New Task' : 'Edit Task'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Buy groceries',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Milk, eggs, bread',
                  alignLabelWithHint: true, // Align label to top for multiline
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  'Due Date: ${_selectedDueDate.toLocal().toString().substring(0, 16)}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDateTime(context),
                contentPadding: EdgeInsets.zero, // Remove default padding
              ),
              // Only show "Completed" checkbox if editing an existing task
              if (widget.task != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isCompleted,
                      onChanged: (bool? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _isCompleted = newValue;
                          });
                        }
                      },
                    ),
                    const Text('Mark as Completed'),
                  ],
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  widget.task == null ? 'Add Task' : 'Save Changes',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

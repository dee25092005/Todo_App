import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
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

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save form fields

      final tasksNotifier = ref.read(tasksProvider.notifier);
      if (widget.task == null) {
        // Adding a new task
        final newTask = Task(
          id: const Uuid().v4(), // Generate a unique ID
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDueDate,
          isCompleted: _isCompleted,
          createdAt: DateTime.now(), // Set creation timestamp
          updatedAt: DateTime.now(), // Set initial update timestamp
        );
        tasksNotifier.addTask(newTask);
      } else {
        // Editing an existing task
        final updatedTask = widget.task!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          dueDate: _selectedDueDate,
          isCompleted: _isCompleted,
          updatedAt: DateTime.now(), // Update timestamp
        );
        tasksNotifier.updateTask(updatedTask);
      }
      Navigator.of(context).pop(); // Go back to HomeScreen
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
                  'Due Date: ${_selectedDueDate.toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDueDate(context),
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

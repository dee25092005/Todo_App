import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
import 'package:todoo_app/screens/add_edit_task_screen.dart';
import 'package:todoo_app/widgets/task_option.dart';
import 'package:todoo_app/widgets/task_checkbox.dart';

class TaskCard extends ConsumerWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksNotifier = ref.read(tasksProvider.notifier);

    return Card(
      margin: const EdgeInsets.only(bottom: 20.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
        child: Row(
          children: [
            TaskCheckboxAndText(task: task, tasksNotifier: tasksNotifier),
            TaskOptionsButton(
              task: task,
              onSoftDelete: () {
                tasksNotifier.softDeleteTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    // Show a snackbar when task is soft deleted
                    content: Text('Task "${task.title}" deleted.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onEdit: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddEditTaskScreen(task: task),
                  ),
                );
              },
              onRestore: () {
                tasksNotifier.restoreTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task ${task.title} restored.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              onPermanentDelete: () {
                tasksNotifier.hardDeleteTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task ${task.title} permanently deleted.'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

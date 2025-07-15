import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
import 'package:todoo_app/widgets/task_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the tasks provider. It now returns an AsyncValue<List<Task>>.
    final AsyncValue<List<Task>> tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      // --- Loading State ---
      loading: () => const Center(child: CircularProgressIndicator()),
      // --- Error State ---
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error loading tasks: $error',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 16,
            ),
          ),
        ),
      ),
      // --- Data State ---
      data: (tasks) {
        // Filter incomplete tasks that are not deleted

        final List<Task> incompleteTasks = tasks
            .where((task) => !task.isDeleted)
            .toList();
        incompleteTasks.sort((a, b) {
          if (a.isCompleted && !b.isCompleted) {
            return 1;
          }
          if (!a.isCompleted && b.isCompleted) {
            return -1;
          }
          return a.dueDate.compareTo(b.dueDate);
        });

        if (incompleteTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'All clear! No tasks for now.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                Text(
                  'Tap the + button to add one.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(15.0),

            itemCount: incompleteTasks.length,
            itemBuilder: (context, index) {
              final task = incompleteTasks[index];
              return TaskCard(task: task);
            },
          );
        }
      },
    );
  }
}

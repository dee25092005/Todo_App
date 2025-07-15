import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/widgets/task_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetching tasks from the provider
    final AsyncValue<List<Task>> tasksAsync = ref.watch(tasksProvider);

    return tasksAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (error, stackTrace) => Center(
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
      data: (tasks) {
        final List<Task> historyTasks = tasks
            .where((task) => task.isCompleted || task.isDeleted)
            .toList();

        historyTasks.sort((a, b) {
          //deleted on top
          if (a.isDeleted && !b.isDeleted) return 1;
          if (!a.isDeleted && b.isDeleted) return -1;

          if (a.isCompleted && !b.isCompleted) {
            return 1;
          }
          if (!a.isCompleted && b.isCompleted) {
            return -1;
          }

          final aUpdatedAt = a.updatedAt;
          final bUpdatedAt = b.updatedAt;

          int updatedAtComparison = bUpdatedAt.compareTo(aUpdatedAt);
          if (updatedAtComparison != 0) {
            return updatedAtComparison;
          }
          return b.createdAt.compareTo(a.createdAt);
        });

        if (historyTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No Completed or deleted tasks yets',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: historyTasks.length,
            itemBuilder: (context, index) {
              final task = historyTasks[index];
              return TaskCard(task: task);
            },
          );
        }
      },
    );
  }
}

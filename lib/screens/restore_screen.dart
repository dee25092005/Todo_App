// lib/screens/restore_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';
import 'package:todoo_app/widgets/task_card.dart';

class RestoreScreen extends ConsumerWidget {
  // Your class name is RestoreScreen
  const RestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Task>> deletedTasksAsync = ref.watch(
      deletedTasksProvider,
    );

    return Scaffold(
      body: deletedTasksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
        data: (tasks) {
          final List<Task> displayedTasks = tasks;
          displayedTasks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

          if (displayedTasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete_sweep_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No deleted tasks here!', // Updated message
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  Text(
                    'Tasks you mark as deleted will appear here ', // Clarified message
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: displayedTasks.length,
              itemBuilder: (context, index) {
                final task = displayedTasks[index];
                return TaskCard(task: task);
              },
            );
          }
        },
      ),
    );
  }
}

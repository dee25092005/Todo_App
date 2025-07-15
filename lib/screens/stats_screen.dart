// lib/screens/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/providers/task_provider.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsyncValue = ref.watch(tasksProvider);

    return tasksAsyncValue.when(
      data: (tasks) {
        final completedTasks = tasks
            .where((task) => task.isCompleted && !task.isDeleted)
            .length;
        final pendingTasks = tasks
            .where((task) => !task.isCompleted && !task.isDeleted)
            .length;
        final totalTasks = completedTasks + pendingTasks;
        final completionRate = totalTasks > 0
            ? (completedTasks / totalTasks)
            : 0.0;

        final activeTasks = tasks.where((task) => !task.isDeleted).toList();
        final overdueTasks = activeTasks
            .where(
              (task) =>
                  !task.isCompleted && task.dueDate.isBefore(DateTime.now()),
            )
            .length;

        return SingleChildScrollView(
          // Use SingleChildScrollView for potential scrolling
          padding: const EdgeInsets.all(20.0), // Increased padding
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Stretch children horizontally
            children: [
              Text(
                'Look what is this!!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Overview Card
              Card(
                elevation: 2, // Subtle elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ), // Rounded corners
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Performance',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 25), // Separator
                      _buildStatRow(
                        context,
                        'Total Tasks:',
                        totalTasks.toString(),
                        Theme.of(context).colorScheme.onSurface,
                      ),
                      _buildStatRow(
                        context,
                        'Completed:',
                        completedTasks.toString(),
                        Colors.green.shade600,
                      ),
                      _buildStatRow(
                        context,
                        'Pending:',
                        pendingTasks.toString(),
                        Colors.orange.shade700,
                      ),
                      _buildStatRow(
                        context,
                        'Overdue:',
                        overdueTasks.toString(),
                        Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Completion Rate Card with Progress Bar
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completion Rate',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Divider(height: 25),
                      Text(
                        '${(completionRate * 100).toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      LinearProgressIndicator(
                        value: completionRate,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        color: Theme.of(context).colorScheme.secondary,
                        minHeight: 10, // Make the bar a bit thicker
                        borderRadius: BorderRadius.circular(5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Keep pushing forward!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Placeholder for future charts or more detailed insights
              Center(
                child: Text(
                  'More insights coming soon...',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  // Helper method to build consistent stat rows
  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

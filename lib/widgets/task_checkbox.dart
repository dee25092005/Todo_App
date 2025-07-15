// lib/widgets/task_checkbox.dart
import 'package:flutter/material.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';

class TaskCheckboxAndText extends StatelessWidget {
  final Task task;
  final Tasks tasksNotifier;

  const TaskCheckboxAndText({
    super.key,
    required this.task,
    required this.tasksNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          // Task checkbox
          Checkbox(
            value: task.isCompleted,
            onChanged: (bool? newValue) {
              if (newValue != null) {
                final updatedTask = task.copyWith(
                  isCompleted: newValue,
                  updatedAt: DateTime.now(),
                );
                tasksNotifier.updateTask(updatedTask);
              }
            },
            activeColor: Theme.of(
              context,
            ).colorScheme.secondary, // Use theme accent color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          // Task title text
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    // Use theme colors for title
                    color: task.isCompleted
                        ? Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color // Lighter grey for completed
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface, // Main text color
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Description text (optional)
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 13,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      // Use theme colors for description
                      color: task.isCompleted
                          ? Theme.of(context).textTheme.bodySmall?.color
                          : Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant, // Secondary text color
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  'Due: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    // Use theme error color for due date, or a different color for completed
                    color: task.isCompleted
                        ? Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color // Use bodySmall color for completed
                        : Theme.of(context)
                              .colorScheme
                              .error, // Error color for active due dates
                  ),
                ),
                Text(
                  'Created at ${task.createdAt.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color, // Use theme bodySmall color
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

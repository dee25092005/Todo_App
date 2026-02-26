// lib/widgets/task_checkbox.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoo_app/models/task.dart';
import 'package:todoo_app/providers/task_provider.dart';

class TaskCheckboxAndText extends ConsumerStatefulWidget {
  final Task task;
  final Tasks tasksNotifier;

  const TaskCheckboxAndText({
    super.key,
    required this.task,
    required this.tasksNotifier,
  });

  @override
  ConsumerState<TaskCheckboxAndText> createState() =>
      _TaskCheckboxAndTextState();
}

class _TaskCheckboxAndTextState extends ConsumerState<TaskCheckboxAndText> {
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          // Task checkbox
          _isProcessing
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Checkbox(
                  value: widget.task.isCompleted,
                  onChanged: (bool? value) async {
                    if (value == null) return;

                    // 1. Lock the UI
                    setState(() => _isProcessing = true);

                    // 2. Perform the update
                    final updatedTask = widget.task.copyWith(
                      isCompleted: value,
                    );
                    await widget.tasksNotifier.updateTask(updatedTask);

                    // 3. Unlock (only if widget is still on screen)
                    if (mounted) {
                      setState(() => _isProcessing = false);
                    }
                  },
                ),

          // Task title text
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    // Use theme colors for title
                    color: widget.task.isCompleted
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
                if (widget.task.description.isNotEmpty) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    widget.task.description,
                    style: TextStyle(
                      fontSize: 13,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                      // Use theme colors for description
                      color: widget.task.isCompleted
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
                  //show with time
                  'Due: ${widget.task.dueDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    // Use theme error color for due date, or a different color for completed
                    color: widget.task.isCompleted
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
                  'Created at ${widget.task.createdAt.toLocal().toString().split(' ')[0]}',
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

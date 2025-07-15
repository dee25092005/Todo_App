import 'package:flutter/material.dart';
import 'package:todoo_app/models/task.dart';

class TaskOptionsButton extends StatelessWidget {
  final VoidCallback onSoftDelete;
  final VoidCallback onEdit;
  final VoidCallback? onRestore;
  final VoidCallback? onPermanentDelete;
  final Task task;

  const TaskOptionsButton({
    super.key,
    required this.onSoftDelete,
    required this.onRestore,
    required this.onPermanentDelete,
    required this.onEdit,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.more_vert, color: Colors.grey[700]),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!task.isDeleted) ...[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit Task'),
                    onTap: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever_outlined,
                      color: Color(0xFFFF7D29),
                    ),
                    title: const Text(
                      'Delete Task',
                      style: TextStyle(color: Color(0xFFFF7D29)),
                    ),
                    onTap: () {
                      Navigator.pop(context); //closing bottom sheet
                      _onSoftDeletebtn(context);
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.restore_outlined),
                    title: const Text('Restore Task'),
                    onTap: () {
                      Navigator.pop(context);
                      onRestore?.call();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.black87,
                    ),
                    title: const Text(
                      'Delete Permanently',
                      style: TextStyle(color: Color(0xFFFF7D29)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _showconfrDia(
                        context,
                        title: 'Confirm Permanent Delete',
                        content:
                            'Are you sure you want to permanently delete ${task.title}? This action cannot be undone.',
                        confirmButtonText: 'Delete Permanently',
                        onConfirm: () {
                          onPermanentDelete?.call();
                        },
                      );
                    },
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  void _onSoftDeletebtn(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${task.title} ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSoftDelete();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xFFFF7D29)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showconfrDia(
    BuildContext context, {
    required String title,
    required String content,
    required String confirmButtonText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogcontext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogcontext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogcontext).pop();
                onConfirm();
              },
              child: Text(
                confirmButtonText,
                style: const TextStyle(color: Color(0xFFFF7D29)),
              ),
            ),
          ],
        );
      },
    );
  }
}

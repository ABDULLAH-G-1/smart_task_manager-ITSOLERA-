import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onStatusChanged;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        // Leading: Checkbox for status
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) => onStatusChanged(),
          activeColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),

        // Title & Description (Responsive & Long Text Handling)
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            const SizedBox(height: 8),
            // Priority Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getPriorityColor(task.priority),
                  width: 1,
                ),
              ),
              child: Text(
                task.priority,
                style: TextStyle(
                  fontSize: 12,
                  color: _getPriorityColor(task.priority),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // Trailing: Delete Icon
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          onPressed: onDelete,
        ),
      ),
    );
  }

  // Helper to choose color based on priority
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}

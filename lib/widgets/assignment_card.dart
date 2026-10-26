import 'package:assignment_submission_tracker/models/assignment.dart';
import 'package:flutter/material.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  final Assignment assignment;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  Color get statusColor {
    if (assignment.isOverdue) return const Color(0xFFD44D5C);
    if (assignment.isCompleted) return const Color(0xFF1D9B72);
    if (assignment.status == 'In Progress') return const Color(0xFFE38B25);
    return const Color(0xFF5B4BDB);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(14, 12, 7, 12),
        leading: Checkbox(
          value: assignment.isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          assignment.title,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            decoration:
                assignment.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${assignment.subject} · ${assignment.isOverdue ? 'Overdue' : assignment.status}\n${assignment.priority} priority',
            style: TextStyle(color: statusColor),
          ),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (action) {
            if (action == 'toggle') onToggle();
            if (action == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'toggle',
              child: Text('Toggle completion'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:assignment_submission_tracker/models/assignment.dart';
import 'package:assignment_submission_tracker/services/assignment_storage.dart';
import 'package:flutter/material.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final AssignmentStorage storage = AssignmentStorage();
  List<Assignment> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    final saved = await storage.loadAssignments();

    if (!mounted) return;

    setState(() {
      assignments = saved;
      isLoading = false;
    });
  }

  int get completed =>
      assignments.where((assignment) => assignment.isCompleted).length;

  int get overdue =>
      assignments.where((assignment) => assignment.isOverdue).length;

  int get inProgress =>
      assignments
          .where((assignment) => assignment.status == 'In Progress')
          .length;

  double get progress =>
      assignments.isEmpty ? 0 : completed / assignments.length;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              const Text(
                'Your insights',
                style: TextStyle(
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'See the progress your study routine is creating.',
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E7FF),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          color: Color(0xFF5B4BDB),
                        ),
                        SizedBox(width: 9),
                        Text(
                          'SDG 4 · Quality Education',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      '$completed of ${assignments.length} assignments completed',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 11,
                        backgroundColor: Colors.white,
                        color: const Color(0xFF5B4BDB),
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      'Organising academic work supports consistent learning, responsible planning, and fewer missed deadlines.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
                children: [
                  _InsightTile(
                    icon: Icons.assignment_turned_in_outlined,
                    value: '$completed',
                    label: 'Completed',
                    color: const Color(0xFF1D9B72),
                  ),
                  _InsightTile(
                    icon: Icons.pending_actions_outlined,
                    value: '$inProgress',
                    label: 'In progress',
                    color: const Color(0xFFE38B25),
                  ),
                  _InsightTile(
                    icon: Icons.warning_amber_rounded,
                    value: '$overdue',
                    label: 'Overdue',
                    color: const Color(0xFFD44D5C),
                  ),
                  _InsightTile(
                    icon: Icons.percent_rounded,
                    value: '${(progress * 100).round()}%',
                    label: 'Completion rate',
                    color: const Color(0xFF5B4BDB),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 13),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(label),
            ],
          ),
        ],
      ),
    );
  }
}
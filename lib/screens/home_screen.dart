import 'package:assignment_submission_tracker/models/assignment.dart';
import 'package:assignment_submission_tracker/services/assignment_storage.dart';
import 'package:assignment_submission_tracker/widgets/sdg_impact_card.dart';
import 'package:assignment_submission_tracker/widgets/stat_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AssignmentStorage _storage = AssignmentStorage();
  List<Assignment> assignments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  Future<void> loadAssignments() async {
    final savedAssignments = await _storage.loadAssignments();

    if (!mounted) return;

    setState(() {
      assignments = savedAssignments;
      isLoading = false;
    });
  }

  int get completedCount =>
      assignments.where((assignment) => assignment.isCompleted).length;

  int get overdueCount =>
      assignments.where((assignment) => assignment.isOverdue).length;

  double get completionRate =>
      assignments.isEmpty ? 0 : completedCount / assignments.length;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF9F8FF),
            Color(0xFFF0EEFF),
            Color(0xFFF9F8FF),
          ],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),
          children: [
            const Text(
              'ASSIGNMENT SUBMISSION TRACKER',
              style: TextStyle(
                color: Color(0xFF5B4BDB),
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep Tracking Your Progress!',
              style: TextStyle(
                fontSize: 36,
                height: 1.04,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4031BF),
                    Color(0xFF796CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.auto_graph_rounded,
                        color: Color(0xFFD8D4FF),
                      ),
                      SizedBox(width: 9),
                      Text(
                        'YOUR ACADEMIC MOMENTUM',
                        style: TextStyle(
                          color: Color(0xFFD8D4FF),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '${assignments.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'assignments in your planner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completionRate,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFFC9FFDF),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    '${(completionRate * 100).round()}% completed · Keep building your routine',
                    style: const TextStyle(color: Color(0xFFE5E2FF)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.verified_outlined,
                    number: '$completedCount',
                    label: 'Completed',
                    color: const Color(0xFF1D9B72),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.notification_important_outlined,
                    number: '$overdueCount',
                    label: 'Needs attention',
                    color: const Color(0xFFD44D5C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SdgImpactCard(),
            const SizedBox(height: 24),
            const Text(
              'Quick overview',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            if (assignments.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Your planner is ready. Open the Planner tab to add your first assignment.',
                  ),
                ),
              )
            else
              ...assignments.take(3).map(
                    (assignment) => Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: assignment.isOverdue
                              ? const Color(0xFFFFE7EA)
                              : const Color(0xFFE8E5FF),
                          child: Icon(
                            assignment.isOverdue
                                ? Icons.priority_high_rounded
                                : Icons.assignment_outlined,
                            color: assignment.isOverdue
                                ? const Color(0xFFD44D5C)
                                : const Color(0xFF5B4BDB),
                          ),
                        ),
                        title: Text(
                          assignment.title,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${assignment.subject} · ${assignment.isOverdue ? 'Overdue' : assignment.status}',
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
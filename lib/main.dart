import 'package:assignment_submission_tracker/screens/about_screen.dart';
import 'package:assignment_submission_tracker/screens/home_screen.dart';
import 'package:assignment_submission_tracker/screens/insights_screen.dart';
import 'package:assignment_submission_tracker/screens/planner_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AssignmentTrackerApp());
}

class AssignmentTrackerApp extends StatelessWidget {
  const AssignmentTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assignment Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B4BDB),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F7FF),
      ),
      home: const AssignmentTrackerHome(),
    );
  }
}

class AssignmentTrackerHome extends StatefulWidget {
  const AssignmentTrackerHome({super.key});

  @override
  State<AssignmentTrackerHome> createState() =>
      _AssignmentTrackerHomeState();
}

class _AssignmentTrackerHomeState extends State<AssignmentTrackerHome> {
  int selectedTab = 0;
  int refreshKey = 0;

  void refreshAssignments() {
    setState(() => refreshKey++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: [
          HomeScreen(key: ValueKey('home-$refreshKey')),
          PlannerScreen(
            key: ValueKey('planner-$refreshKey'),
            onAssignmentsChanged: refreshAssignments,
          ),
          InsightsScreen(key: ValueKey('insights-$refreshKey')),
          const AboutScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Planner',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
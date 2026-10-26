import 'dart:convert';

import 'package:assignment_submission_tracker/models/assignment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignmentStorage {
  static const _storageKey = 'saved_assignments';

  Future<List<Assignment>> loadAssignments() async {
    final preferences = await SharedPreferences.getInstance();
    final savedAssignments = preferences.getStringList(_storageKey) ?? [];

    return savedAssignments
        .map((item) => Assignment.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> saveAssignments(List<Assignment> assignments) async {
    final preferences = await SharedPreferences.getInstance();

    final savedAssignments = assignments
        .map((assignment) => jsonEncode(assignment.toJson()))
        .toList();

    await preferences.setStringList(_storageKey, savedAssignments);
  }
}
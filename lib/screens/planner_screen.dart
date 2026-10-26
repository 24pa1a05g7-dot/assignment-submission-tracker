import 'package:assignment_submission_tracker/models/assignment.dart';
import 'package:assignment_submission_tracker/services/assignment_storage.dart';
import 'package:assignment_submission_tracker/widgets/assignment_card.dart';
import 'package:flutter/material.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({
    super.key,
    required this.onAssignmentsChanged,
  });

  final VoidCallback onAssignmentsChanged;

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final AssignmentStorage storage = AssignmentStorage();
  final TextEditingController searchController = TextEditingController();

  List<Assignment> assignments = [];
  String filter = 'All';
  String query = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAssignments();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadAssignments() async {
    final saved = await storage.loadAssignments();

    if (!mounted) return;

    setState(() {
      assignments = saved;
      loading = false;
    });
  }

  Future<void> save() async {
    await storage.saveAssignments(assignments);
    widget.onAssignmentsChanged();
  }

  List<Assignment> get visibleAssignments {
    final results = assignments.where((assignment) {
      final matchesSearch =
          assignment.title.toLowerCase().contains(query.toLowerCase()) ||
              assignment.subject.toLowerCase().contains(query.toLowerCase());

      final matchesFilter = switch (filter) {
        'Pending' => assignment.status == 'Pending',
        'In Progress' => assignment.status == 'In Progress',
        'Completed' => assignment.status == 'Completed',
        'Overdue' => assignment.isOverdue,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();

    results.sort((first, second) => first.dueDate.compareTo(second.dueDate));
    return results;
  }

  String dateLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> openAssignmentForm([Assignment? existing]) async {
    final formKey = GlobalKey<FormState>();
    final title = TextEditingController(text: existing?.title ?? '');
    final subject = TextEditingController(text: existing?.subject ?? '');
    var dueDate = existing?.dueDate ?? DateTime.now();
    var priority = existing?.priority ?? 'Medium';
    var status = existing?.status ?? 'Pending';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 48),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: SizedBox(
                            width: 42,
                            child: Divider(thickness: 4),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          existing == null
                              ? 'Add assignment'
                              : 'Edit assignment',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: title,
                          decoration: const InputDecoration(
                            labelText: 'Assignment title',
                            prefixIcon: Icon(Icons.assignment_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter assignment title'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: subject,
                          decoration: const InputDecoration(
                            labelText: 'Subject',
                            prefixIcon: Icon(Icons.menu_book_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Enter subject'
                                  : null,
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final selected = await showDatePicker(
                              context: context,
                              initialDate: dueDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2035),
                            );

                            if (selected != null) {
                              setSheetState(() => dueDate = selected);
                            }
                          },
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text('Due date: ${dateLabel(dueDate)}'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(),
                          ),
                          items: const ['High', 'Medium', 'Low']
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setSheetState(() => priority = value);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const ['Pending', 'In Progress', 'Completed']
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setSheetState(() => status = value);
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;

                              final assignment = existing == null
                                  ? Assignment(
                                      id: DateTime.now()
                                          .microsecondsSinceEpoch
                                          .toString(),
                                      title: title.text.trim(),
                                      subject: subject.text.trim(),
                                      dueDate: dueDate,
                                      priority: priority,
                                      status: status,
                                    )
                                  : existing.copyWith(
                                      title: title.text.trim(),
                                      subject: subject.text.trim(),
                                      dueDate: dueDate,
                                      priority: priority,
                                      status: status,
                                    );

                              setState(() {
                                if (existing == null) {
                                  assignments.add(assignment);
                                } else {
                                  final index = assignments.indexWhere(
                                    (item) => item.id == existing.id,
                                  );
                                  assignments[index] = assignment;
                                }
                              });

                              await save();

                              if (mounted) {
                                Navigator.of(this.context).pop();
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(
                              existing == null
                                  ? 'Save assignment'
                                  : 'Save changes',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> toggleCompletion(Assignment assignment) async {
    final updated = assignment.copyWith(
      status: assignment.isCompleted ? 'Pending' : 'Completed',
    );

    setState(() {
      final index = assignments.indexWhere(
        (item) => item.id == assignment.id,
      );
      assignments[index] = updated;
    });

    await save();
  }

  Future<void> deleteAssignment(Assignment assignment) async {
    setState(() {
      assignments.removeWhere((item) => item.id == assignment.id);
    });

    await save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAssignmentForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add assignment'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 105),
                children: [
                  const Text(
                    'Your planner',
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Keep coursework visible, focused, and achievable.',
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() => query = value.trim());
                    },
                    decoration: InputDecoration(
                      hintText: 'Search assignments or subjects',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Pending',
                        'In Progress',
                        'Completed',
                        'Overdue',
                      ]
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(item),
                                selected: filter == item,
                                onSelected: (_) {
                                  setState(() => filter = item);
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (visibleAssignments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(35),
                      child: Center(
                        child: Text('No assignments found.'),
                      ),
                    )
                  else
                    ...visibleAssignments.map(
                      (assignment) => AssignmentCard(
                        assignment: assignment,
                        onTap: () => openAssignmentForm(assignment),
                        onToggle: () => toggleCompletion(assignment),
                        onDelete: () => deleteAssignment(assignment),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
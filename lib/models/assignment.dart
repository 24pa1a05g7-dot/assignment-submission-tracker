class Assignment {
  const Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String priority;
  final String status;

  bool get isCompleted => status == 'Completed';

  bool get isOverdue {
    final today = DateTime.now();
    final deadline = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final currentDay = DateTime(today.year, today.month, today.day);

    return !isCompleted && deadline.isBefore(currentDay);
  }

  Assignment copyWith({
    String? title,
    String? subject,
    DateTime? dueDate,
    String? priority,
    String? status,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      title: json['title'] as String,
      subject: json['subject'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: json['priority'] as String,
      status: json['status'] as String,
    );
  }
}
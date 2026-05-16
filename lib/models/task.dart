class Task {
  String title;
  String description;
  String priority; // low, medium, high
  String category;
  DateTime dueDate;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Helper method to copy a task with updated fields
  Task copyWith({
    String? title,
    String? description,
    String? priority,
    String? category,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

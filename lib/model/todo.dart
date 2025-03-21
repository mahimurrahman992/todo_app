class Task {
  int id;  // Unique ID for each task
  String title;  // Task title
  String description;  // Task description
  int createdAt;  // Timestamp of when the task was created
  String status;  // Task status ('ready', 'pending', 'completed')

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  // Convert Task to a Map (used for storage or API)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'status': status,
    };
  }

  // Convert a Map to a Task (used when retrieving from storage or API)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdAt: map['created_at'],
      status: map['status'],
    );
  }
}

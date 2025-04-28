class Task {
  final String id;
  final String title;
  final DateTime date;
  bool isDone;

  Task(
      {required this.id,
      required this.title,
      required this.date,
      required this.isDone});

  Task copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? isDone,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }
}

class Task {
  final int id;
  final String title;
  final DateTime date;
  bool isDone;
  final String userId;

  Task(
      {required this.id,
      required this.title,
      required this.date,
      required this.isDone,
      required this.userId});

  Task copyWith({
    int? id,
    String? title,
    DateTime? date,
    bool? isDone,
    String? userId,
  }) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        isDone: isDone ?? this.isDone,
        userId: userId ?? this.userId);
  }
}

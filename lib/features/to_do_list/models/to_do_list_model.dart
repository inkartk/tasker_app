class Task {
  final String title;
  final DateTime date;
  bool isDone;

  Task({
    required this.title,
    required this.date,
    this.isDone = false,
  });
}

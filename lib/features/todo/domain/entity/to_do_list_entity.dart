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
}

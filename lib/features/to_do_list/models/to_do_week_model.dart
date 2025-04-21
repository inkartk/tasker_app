class TaskWeek {
  final String title;
  final DateTime date;
  bool isDone;

  TaskWeek({
    required this.title,
    required this.date,
    this.isDone = false,
  });
}

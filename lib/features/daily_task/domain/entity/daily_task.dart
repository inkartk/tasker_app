import 'package:my_the_best_project/features/daily_task/domain/entity/subtasks.dart';

class DailyTask {
  final int? id;
  final String userID;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final bool isDone;
  final List<SubTask> subTasks;

  DailyTask({
    this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.isDone,
    List<SubTask>? subTasks,
  }) : subTasks = subTasks ?? <SubTask>[];

  DailyTask copyWith({
    int? id,
    String? userID,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? category,
    bool? isDone,
    List<SubTask>? subTasks,
  }) {
    return DailyTask(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
      subTasks: subTasks ?? this.subTasks,
    );
  }
}

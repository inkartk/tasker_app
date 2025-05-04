import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';

class DailyTaskModel extends DailyTask {
  DailyTaskModel({
    super.id,
    required super.userID,
    required super.title,
    required super.description,
    required super.startTime,
    required super.endTime,
    required super.category,
    required super.isDone,
    super.subTasks,
  });

  factory DailyTaskModel.fromJson(Map<String, dynamic> json) {
    return DailyTaskModel(
      id: json['id'] as int?,
      userID: json['userID'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      category: json['category'] as String,
      isDone: json['isDone'] as bool,
      subTasks: (json['subTasks'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userID': userID,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'category': category,
      'isDone': isDone,
      'subTasks': subTasks,
    };
  }

  DailyTask toEntity() => this;

  static DailyTaskModel fromEntity(DailyTask task) => DailyTaskModel(
        id: task.id,
        userID: task.userID,
        title: task.title,
        description: task.description,
        startTime: task.startTime,
        endTime: task.endTime,
        category: task.category,
        isDone: task.isDone,
        subTasks: task.subTasks,
      );
}

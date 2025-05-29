import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/subtasks.dart';

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
      subTasks: (json['subTasks'] as List<dynamic>?)
          ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'category': category,
      'isDone': isDone,
      'subTasks': subTasks.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DailyTaskModel copyWith({
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
    return DailyTaskModel(
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

  DailyTask toEntity() => this;

  static DailyTaskModel fromEntity(DailyTask e) {
    return DailyTaskModel(
      id: e.id,
      userID: e.userID,
      title: e.title,
      description: e.description,
      startTime: e.startTime,
      endTime: e.endTime,
      category: e.category,
      isDone: e.isDone,
      subTasks: e.subTasks,
    );
  }
}

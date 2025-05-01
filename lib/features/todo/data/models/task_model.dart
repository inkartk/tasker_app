import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';

class TaskModel extends Task {
  TaskModel({
    required super.id,
    required super.title,
    required super.date,
    required super.isDone,
    required super.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        isDone: json['isDone'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'isDone': isDone,
      'userId': userId
    };
  }

  Task toEntity() => this;

  static TaskModel fromEntity(Task task) => TaskModel(
      id: task.id,
      title: task.title,
      date: task.date,
      isDone: task.isDone,
      userId: task.userId);
}

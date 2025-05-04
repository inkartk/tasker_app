// lib/features/daily_task/data/local_data_source/daily_task_local_data_source.dart

import 'dart:convert';

import 'package:drift/drift.dart';

import '../../domain/entity/daily_task.dart';
import 'daily_app_database.dart';

abstract class DailyTaskLocalDataSource {
  Future<DailyTask> addDailyTask(DailyTask dailyTask);
  Future<void> deleteDailyTask(DailyTask dailyTask);
  Future<void> editDailyTask(DailyTask dailyTask);
  Future<List<DailyTask>> getDailyTask(DateTime day);
}

class DailyTaskLocalDataSourceImpl implements DailyTaskLocalDataSource {
  final DailyAppDatabase db;
  DailyTaskLocalDataSourceImpl({required this.db});

  @override
  Future<DailyTask> addDailyTask(DailyTask task) async {
    final companion = DailyTasksCompanion(
      userId: Value(task.userID),
      title: Value(task.title),
      description: Value(task.description),
      startTime: Value(task.startTime),
      endTime: Value(task.endTime),
      category: Value(task.category),
      isDone: Value(task.isDone),
      subTasksJson: Value(jsonEncode(task.subTasks)),
    );
    final newId = await db.addDailyTask(companion);
    return task.copyWith(id: newId);
  }

  @override
  Future<void> deleteDailyTask(DailyTask task) {
    assert(task.id != null, 'Для удаления нужен id задачи');
    return db.deleteDailyTask(task.id!);
  }

  @override
  Future<void> editDailyTask(DailyTask task) {
    assert(task.id != null, 'Для редактирования нужен id задачи');
    final entity = DailyTaskEntity(
      id: task.id!,
      userId: task.userID,
      title: task.title,
      description: task.description,
      startTime: task.startTime,
      endTime: task.endTime,
      category: task.category,
      isDone: task.isDone,
      subTasksJson: jsonEncode(task.subTasks),
    );
    return db.updateDailyTask(entity);
  }

  @override
  Future<List<DailyTask>> getDailyTask(DateTime day) async {
    final entities = await db.getTasksForDay(day);
    return entities.map((e) {
      final list =
          (json.decode(e.subTasksJson) as List<dynamic>).cast<String>();
      return DailyTask(
        id: e.id,
        userID: e.userId,
        title: e.title,
        description: e.description,
        startTime: e.startTime,
        endTime: e.endTime,
        category: e.category,
        isDone: e.isDone,
        subTasks: list,
      );
    }).toList();
  }
}

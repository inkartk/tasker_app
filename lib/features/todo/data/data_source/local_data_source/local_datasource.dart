import 'dart:convert';

import 'package:my_the_best_project/features/todo/data/models/task_model.dart';
import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalDataSource {
  Future<void> addTask(Task task);
  Future<void> deleteTask(Task task);
  Future<List<TaskModel>> getTaskForDay(DateTime day);
  Future<List<TaskModel>> getAllTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
}

const CACHED_TASK_LIST = 'CACHED_TASK_LIST';

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> addTask(Task task) async {
    final jsonTaskList =
        sharedPreferences.getStringList(CACHED_TASK_LIST) ?? [];

    final taskModel = TaskModel.fromEntity(task);
    jsonTaskList.add(jsonEncode(taskModel.toJson()));
    await sharedPreferences.setStringList(CACHED_TASK_LIST, jsonTaskList);
  }

  @override
  Future<void> deleteTask(Task task) async {
    final jsonTaskList =
        sharedPreferences.getStringList(CACHED_TASK_LIST) ?? [];

    jsonTaskList.removeWhere((jsonStr) {
      final taskModel = TaskModel.fromJson(jsonDecode(jsonStr));
      return taskModel.id == task.id;
    });

    await sharedPreferences.setStringList(CACHED_TASK_LIST, jsonTaskList);
  }

  @override
  Future<List<TaskModel>> getTaskForDay(DateTime day) async {
    final jsonTaskList = sharedPreferences.getStringList(CACHED_TASK_LIST);

    if (jsonTaskList == null) return [];

    final allTasks = jsonTaskList.map((task) {
      final model = TaskModel.fromJson(jsonDecode(task));
      return model;
    }).toList();

    final filteredTasks = allTasks.where((task) {
      return task.date.day == day.day &&
          task.date.month == day.month &&
          task.date.year == day.year;
    }).toList();

    return filteredTasks;
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final jsonTaskList =
        sharedPreferences.getStringList(CACHED_TASK_LIST) ?? [];
    return jsonTaskList.map((jsonStr) {
      return TaskModel.fromJson(jsonDecode(jsonStr));
    }).toList();
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final jsonList = tasks.map((model) => jsonEncode(model.toJson())).toList();
    await sharedPreferences.setStringList(CACHED_TASK_LIST, jsonList);
  }
}

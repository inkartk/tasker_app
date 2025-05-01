import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/app_database.dart';
import 'package:my_the_best_project/features/todo/data/models/task_model.dart';
import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';

abstract class LocalDataSource {
  Future<void> addTask(Task task);
  Future<void> deleteTask(Task task);
  Future<List<TaskModel>> getTaskForDay(DateTime day);
  Future<List<TaskModel>> getAllTasks();
  Future<void> updateTask(Task task);
}

class LocalDataSourceImpl implements LocalDataSource {
  final AppDatabase database;

  LocalDataSourceImpl({required this.database});

  @override
  Future<void> addTask(Task task) async {
    await database.insertTask(
      TasksCompanion(
        title: Value(task.title),
        isDone: Value(task.isDone),
        date: Value(task.date),
        userId: Value(FirebaseAuth.instance.currentUser!.uid),
      ),
    );
  }

  @override
  Future<void> deleteTask(Task task) async {
    await (database.delete(database.tasks)
          ..where((tbl) => tbl.id.equals(task.id)))
        .go();
  }

  @override
  @override
  Future<List<TaskModel>> getTaskForDay(DateTime day) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);

    final tasks = await (database.select(database.tasks)
          ..where((tbl) =>
              tbl.userId.equals(uid) &
              tbl.date.isBiggerOrEqualValue(start) &
              tbl.date.isSmallerThanValue(end)))
        .get();

    return tasks
        .map((e) => TaskModel(
              id: e.id,
              title: e.title,
              isDone: e.isDone,
              date: e.date,
              userId: e.userId,
            ))
        .toList();
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final allTasks = await (database.select(database.tasks)
          ..where((tbl) => tbl.userId.equals(uid)))
        .get();

    return allTasks
        .map((e) => TaskModel(
              id: e.id,
              title: e.title,
              isDone: e.isDone,
              date: e.date,
              userId: e.userId,
            ))
        .toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    await database.updateTask(
      TaskEntity(
          id: task.id,
          title: task.title,
          isDone: task.isDone,
          date: task.date,
          userId: task.userId),
    );
  }
}

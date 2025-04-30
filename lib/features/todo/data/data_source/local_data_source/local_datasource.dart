import 'package:drift/drift.dart';
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
  Future<List<TaskModel>> getTaskForDay(DateTime day) async {
    final allTasks = await database.getAllTasks();

    return allTasks
        .where((task) =>
            task.date.year == day.year &&
            task.date.month == day.month &&
            task.date.day == day.day)
        .map((e) => TaskModel(
              id: e.id,
              title: e.title,
              isDone: e.isDone,
              date: e.date,
            ))
        .toList();
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final allTasks = await database.getAllTasks();

    return allTasks
        .map((e) => TaskModel(
              id: e.id,
              title: e.title,
              isDone: e.isDone,
              date: e.date,
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
      ),
    );
  }
}

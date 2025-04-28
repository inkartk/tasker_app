import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/local_datasource.dart';
import 'package:my_the_best_project/features/todo/data/models/task_model.dart';
import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';

class RepositoryImpl extends Repository {
  final LocalDataSource localDataSource;

  RepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await localDataSource.addTask(model); // добавил await
  }

  @override
  Future<void> deleteTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await localDataSource.deleteTask(model); // добавил await
  }

  @override
  Future<List<Task>> getTaskForDay(DateTime day) async {
    final result = await localDataSource.getTaskForDay(day);
    return result.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> updateTask(Task task) async {
    final allTasks =
        await localDataSource.getAllTasks(); // поменял на getAllTasks
    final updatedTasks = allTasks.map((taskModel) {
      if (taskModel.id == task.id) {
        return TaskModel.fromEntity(task); // заменяем на новый
      }
      return taskModel;
    }).toList();
    await localDataSource.saveTasks(updatedTasks);
  }
}

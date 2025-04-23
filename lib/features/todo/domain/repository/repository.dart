import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';

abstract class Repository {
  Future<void> addTask(Task task);
  Future<void> deleteTask(Task task);
  Future<List<Task>> getTaskForDay(DateTime day);
}

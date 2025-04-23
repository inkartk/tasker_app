import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';

class AddTask {
  final Repository repository;

  AddTask({required this.repository});

  Future<void> call(Task task) async {
    return await repository.addTask(task);
  }
}

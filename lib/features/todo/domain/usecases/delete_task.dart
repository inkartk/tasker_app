import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';

class DeleteTask {
  final Repository repository;

  DeleteTask({required this.repository});

  Future<void> call(Task task) async {
    return await repository.deleteTask(task);
  }
}

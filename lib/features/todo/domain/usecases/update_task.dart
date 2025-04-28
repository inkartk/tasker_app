import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';

class UpdateTask {
  final Repository repository;

  UpdateTask({required this.repository});

  Future<void> call(Task task) async {
    return repository.updateTask(task);
  }
}

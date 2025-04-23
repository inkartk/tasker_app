import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';

class GetTask {
  final Repository repository;

  GetTask({required this.repository});

  Future<List<Task>> call(DateTime day) async {
    return await repository.getTaskForDay(day);
  }
}

import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';

class EditDailyTask {
  final DailyTaskRepository dailyTaskRepository;

  EditDailyTask({required this.dailyTaskRepository});

  Future<void> call(DailyTask dailyTask) async {
    return await dailyTaskRepository.editDailyTask(dailyTask);
  }
}

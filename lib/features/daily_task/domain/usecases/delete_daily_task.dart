import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';

class DeleteDailyTask {
  final DailyTaskRepository dailyTaskRepository;

  DeleteDailyTask({required this.dailyTaskRepository});

  Future<void> call(DailyTask dailyTask) async {
    return await dailyTaskRepository.deleteDailyTask(dailyTask);
  }
}

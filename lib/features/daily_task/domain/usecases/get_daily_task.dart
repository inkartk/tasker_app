import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';

class GetDailyTask {
  final DailyTaskRepository dailyTaskRepository;

  GetDailyTask({required this.dailyTaskRepository});

  Future<List<DailyTask>> call(String userID, DateTime day) async {
    return await dailyTaskRepository.getDailyTask(userID, day);
  }
}

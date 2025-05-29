// lib/features/daily_task/domain/use_case/add_daily_task.dart

import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';

class AddDailyTask {
  final DailyTaskRepository dailyTaskRepository;

  AddDailyTask({required this.dailyTaskRepository});

  Future<DailyTask> call(DailyTask dailyTask) {
    return dailyTaskRepository.addDailyTask(dailyTask);
  }
}

import '../../domain/entity/daily_task.dart';
import '../../domain/repository/daily_task_repository.dart';
import '../local_data_source/daily_task_local_data_source.dart';

class DailyTaskRepositoryImpl implements DailyTaskRepository {
  final DailyTaskLocalDataSource localDs;
  DailyTaskRepositoryImpl({required this.localDs});

  @override
  Future<DailyTask> addDailyTask(DailyTask dailyTask) {
    return localDs.addDailyTask(dailyTask);
  }

  @override
  Future<void> deleteDailyTask(DailyTask dailyTask) {
    return localDs.deleteDailyTask(dailyTask);
  }

  @override
  Future<void> editDailyTask(DailyTask dailyTask) {
    return localDs.editDailyTask(dailyTask);
  }

  @override
  Future<List<DailyTask>> getDailyTask(DateTime day) {
    return localDs.getDailyTask(day);
  }
}

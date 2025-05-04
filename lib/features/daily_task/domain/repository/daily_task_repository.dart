import '../entity/daily_task.dart';

abstract class DailyTaskRepository {
  Future<DailyTask> addDailyTask(DailyTask dailyTask);
  Future<void> deleteDailyTask(DailyTask dailyTask);
  Future<void> editDailyTask(DailyTask dailyTask);
  Future<List<DailyTask>> getDailyTask(DateTime day);
}

import 'package:drift/drift.dart';
import 'package:my_the_best_project/features/daily_task/data/local_data_source/daily_app_database.dart';

abstract class StatisticsLocalDataSource {
  Future<int> getTotalTasksCount(String userId);
  Future<int> getCompletedTasksCount(String userId);
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final DailyAppDatabase db;

  StatisticsLocalDataSourceImpl(this.db);

  @override
  Future<int> getTotalTasksCount(String userId) {
    return (db.selectOnly(db.dailyTasks)
          ..addColumns([db.dailyTasks.id.count()])
          ..where(db.dailyTasks.userId.equals(userId)))
        .map((row) => row.read(db.dailyTasks.id.count())!)
        .getSingle();
  }

  @override
  Future<int> getCompletedTasksCount(String userId) {
    return (db.selectOnly(db.dailyTasks)
          ..addColumns([db.dailyTasks.id.count()])
          ..where(db.dailyTasks.userId.equals(userId))
          ..where(db.dailyTasks.isDone.equals(true)))
        .map((row) => row.read(db.dailyTasks.id.count())!)
        .getSingle();
  }
}

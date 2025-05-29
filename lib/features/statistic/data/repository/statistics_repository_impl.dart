import 'package:my_the_best_project/features/statistic/data/datasource/statistics_local_data_source.dart';
import 'package:my_the_best_project/features/statistic/domain/entity/task_statistics.dart';
import 'package:my_the_best_project/features/statistic/domain/repository/statistic_repository.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDataSource localDataSource;
  final String userId;

  StatisticsRepositoryImpl({
    required this.localDataSource,
    required this.userId,
  });

  @override
  Future<TaskStatistics> getTaskStatistics() async {
    final total = await localDataSource.getTotalTasksCount(userId);
    final done = await localDataSource.getCompletedTasksCount(userId);
    return TaskStatistics(
      totalTasks: total,
      completedTasks: done,
    );
  }
}

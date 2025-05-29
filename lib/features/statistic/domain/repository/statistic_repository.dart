import 'package:my_the_best_project/features/statistic/domain/entity/task_statistics.dart';

abstract class StatisticsRepository {
  Future<TaskStatistics> getTaskStatistics();
}

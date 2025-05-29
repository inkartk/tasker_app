import 'package:my_the_best_project/features/statistic/domain/entity/task_statistics.dart';
import 'package:my_the_best_project/features/statistic/domain/repository/statistic_repository.dart';

class GetTaskStatistics {
  final StatisticsRepository repository;

  GetTaskStatistics(this.repository);

  Future<TaskStatistics> call() {
    return repository.getTaskStatistics();
  }
}

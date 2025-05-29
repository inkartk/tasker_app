import 'package:my_the_best_project/features/statistic/domain/entity/task_statistics.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final TaskStatistics stats;
  StatisticsLoaded(this.stats);
}

class StatisticsError extends StatisticsState {
  final String message;
  StatisticsError(this.message);
}

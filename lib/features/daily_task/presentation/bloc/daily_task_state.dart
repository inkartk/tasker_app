import 'package:equatable/equatable.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';

abstract class DailyTaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class DailyTaskEmpty extends DailyTaskState {}

class DailyTaskLoading extends DailyTaskState {}

class DailyTaskLoaded extends DailyTaskState {
  final List<DailyTask> dailyTaskList;

  DailyTaskLoaded({required this.dailyTaskList});
  @override
  List<Object> get props => [dailyTaskList];
}

class DailyTaskErrorState extends DailyTaskState {
  final String dailyTaskError;

  DailyTaskErrorState({required this.dailyTaskError});
  @override
  List<Object> get props => [dailyTaskError];
}

import 'package:equatable/equatable.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';

abstract class DailyTaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDailyTaskEvent extends DailyTaskEvent {
  final DailyTask dailyTask;

  AddDailyTaskEvent({required this.dailyTask});
  @override
  List<Object?> get props => [dailyTask];
}

class DeleteDailyTaskEvent extends DailyTaskEvent {
  final DailyTask dailyTask;

  DeleteDailyTaskEvent({required this.dailyTask});
  @override
  List<Object?> get props => [dailyTask];
}

class EditDailyTaskEvent extends DailyTaskEvent {
  final DailyTask dailyTask;

  EditDailyTaskEvent({required this.dailyTask});
  @override
  List<Object?> get props => [dailyTask];
}

class LoadStatistics extends DailyTaskEvent {
  final int year;
  LoadStatistics(this.year);
  @override
  List<Object?> get props => [year];
}

class LoadDailyTaskEvent extends DailyTaskEvent {
  final String userID;
  final DateTime day;

  LoadDailyTaskEvent({required this.userID, required this.day});
  @override
  List<Object?> get props => [userID, day];
}

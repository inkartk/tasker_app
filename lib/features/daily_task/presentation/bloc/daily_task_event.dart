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

class LoadDailyTaskEvent extends DailyTaskEvent {
  final DateTime day;

  LoadDailyTaskEvent({required this.day});
  @override
  List<Object?> get props => [day];
}

import 'package:equatable/equatable.dart';
import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskEmptyState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> taskList;

  TaskLoadedState({required this.taskList});
  @override
  List<Object> get props => [taskList];
}

class TaskErrorState extends TaskState {
  final String taskError;

  TaskErrorState({required this.taskError});
  @override
  List<Object> get props => [taskError];
}

class TaskAddState extends TaskState {}

class TaskDeleteState extends TaskState {}

class TaskUpdatingState extends TaskState {}

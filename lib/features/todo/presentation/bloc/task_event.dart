import 'package:equatable/equatable.dart';
import 'package:my_the_best_project/features/todo/domain/entity/to_do_list_entity.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TaskAddEvent extends TaskEvent {
  final Task task;

  TaskAddEvent({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskDeleteEvent extends TaskEvent {
  final Task task;

  TaskDeleteEvent({required this.task});
  @override
  List<Object> get props => [task];
}

class TaskGetEvent extends TaskEvent {
  final DateTime day;

  TaskGetEvent({required this.day});

  @override
  List<Object> get props => [day];
}

class TaskUpdatingEvent extends TaskEvent {
  final Task task;

  TaskUpdatingEvent({required this.task});

  @override
  List<Object> get props => [task];
}

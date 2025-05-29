part of 'detail_priority_bloc.dart';

class DetailPriorityTaskState extends Equatable {
  final DailyTask task;
  final int months;
  final int days;
  final int hours;
  final double progress;

  const DetailPriorityTaskState({
    required this.task,
    required this.months,
    required this.days,
    required this.hours,
    required this.progress,
  });

  DetailPriorityTaskState copyWith({
    DailyTask? task,
    int? months,
    int? days,
    int? hours,
    double? progress,
  }) {
    return DetailPriorityTaskState(
      task: task ?? this.task,
      months: months ?? this.months,
      days: days ?? this.days,
      hours: hours ?? this.hours,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object> get props => [task, months, days, hours, progress];
}

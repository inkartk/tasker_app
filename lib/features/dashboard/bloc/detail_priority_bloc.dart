import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/subtasks.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';

part 'detail_priority_state.dart';

class DetailPriorityTaskCubit extends Cubit<DetailPriorityTaskState> {
  final DailyTaskRepository _repository;

  DetailPriorityTaskCubit({
    required DailyTask initialTask,
    required DailyTaskRepository repository,
  })  : _repository = repository,
        super(
          DetailPriorityTaskState(
            task: initialTask,
            months: _calcMonths(initialTask),
            days: _calcDays(initialTask),
            hours: _calcHours(initialTask),
            progress: _calcProgress(initialTask),
          ),
        );

  static int _calcMonths(DailyTask t) {
    final d = t.endTime.difference(t.startTime);
    return d.inDays ~/ 30;
  }

  static int _calcDays(DailyTask t) {
    final d = t.endTime.difference(t.startTime);
    return d.inDays % 30;
  }

  static int _calcHours(DailyTask t) {
    final d = t.endTime.difference(t.startTime);
    return d.inHours % 24;
  }

  static double _calcProgress(DailyTask t) {
    if (t.subTasks.isEmpty) return 0;
    final done = t.subTasks.where((s) => s.isDone).length;
    return done / t.subTasks.length;
  }

  Future<void> toggleSubTask(int index) async {
    final current = state.task;
    final subs = List<SubTask>.from(current.subTasks);
    final s = subs[index];
    subs[index] = s.copyWith(isDone: !s.isDone);

    var updated = current.copyWith(subTasks: subs);
    if (subs.every((s) => s.isDone)) {
      updated = updated.copyWith(isDone: true);
    } else if (current.isDone) {
      updated = updated.copyWith(isDone: false);
    }

    await _repository.editDailyTask(updated);
    emit(
      state.copyWith(
        task: updated,
        progress: _calcProgress(updated),
      ),
    );
  }
}

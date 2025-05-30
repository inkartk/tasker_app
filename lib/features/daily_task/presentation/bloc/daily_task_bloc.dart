import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/add_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/delete_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/edit_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/get_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_state.dart';

class DailyTaskBloc extends Bloc<DailyTaskEvent, DailyTaskState> {
  final AddDailyTask addDailyTask;
  final DeleteDailyTask deleteDailyTask;
  final EditDailyTask editDailyTask;
  final GetDailyTask getDailyTask;

  DailyTaskBloc({
    required this.addDailyTask,
    required this.deleteDailyTask,
    required this.editDailyTask,
    required this.getDailyTask,
  }) : super(DailyTaskEmpty()) {
    on<AddDailyTaskEvent>((event, emit) async {
      try {
        await addDailyTask(event.dailyTask);
        add(LoadDailyTaskEvent(
          userID: event.dailyTask.userID,
          day: event.dailyTask.startTime,
        ));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });

    on<DeleteDailyTaskEvent>((event, emit) async {
      try {
        await deleteDailyTask(event.dailyTask);
        add(LoadDailyTaskEvent(
          userID: event.dailyTask.userID,
          day: event.dailyTask.startTime,
        ));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });
    on<EditDailyTaskEvent>((event, emit) async {
      try {
        await editDailyTask(event.dailyTask);
        add(LoadDailyTaskEvent(
          userID: event.dailyTask.userID,
          day: event.dailyTask.startTime,
        ));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });
    on<LoadDailyTaskEvent>((event, emit) async {
      emit(DailyTaskLoading());
      try {
        final tasks = await getDailyTask(event.userID, event.day);

        final startOfDay = DateTime(
          event.day.year,
          event.day.month,
          event.day.day,
        );
        final endOfDay = DateTime(
          event.day.year,
          event.day.month,
          event.day.day,
          23,
          59,
          59,
          999,
        );

        final filteredTasks = tasks.where((task) {
          final startsOnOrBeforeDayEnd = !task.startTime.isAfter(endOfDay);
          final endsOnOrAfterDayStart = !task.endTime.isBefore(startOfDay);

          return startsOnOrBeforeDayEnd && endsOnOrAfterDayStart;
        }).toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });

        emit(DailyTaskLoaded(dailyTaskList: filteredTasks));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });
  }
}

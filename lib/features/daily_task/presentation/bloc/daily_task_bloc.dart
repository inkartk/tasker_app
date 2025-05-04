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
        final tasks = await getDailyTask(event.dailyTask.startTime);

        final filteredTasks = tasks
            .where((task) =>
                task.startTime.year == event.dailyTask.startTime.year &&
                task.startTime.month == event.dailyTask.startTime.month &&
                task.startTime.day == event.dailyTask.startTime.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });
        emit(DailyTaskLoaded(dailyTaskList: filteredTasks));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });

    on<DeleteDailyTaskEvent>((event, emit) async {
      try {
        await deleteDailyTask(event.dailyTask);
        final tasks = await getDailyTask(event.dailyTask.startTime);

        final filteredTasks = tasks
            .where((task) =>
                task.startTime.year == event.dailyTask.startTime.year &&
                task.startTime.month == event.dailyTask.startTime.month &&
                task.startTime.day == event.dailyTask.startTime.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });
        emit(DailyTaskLoaded(dailyTaskList: filteredTasks));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });
    on<EditDailyTaskEvent>((event, emit) async {
      try {
        await editDailyTask(event.dailyTask);
        final tasks = await getDailyTask(event.dailyTask.startTime);

        final filteredTasks = tasks
            .where((task) =>
                task.startTime.year == event.dailyTask.startTime.year &&
                task.startTime.month == event.dailyTask.startTime.month &&
                task.startTime.day == event.dailyTask.startTime.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });
        emit(DailyTaskLoaded(dailyTaskList: filteredTasks));
      } catch (e) {
        emit(DailyTaskErrorState(dailyTaskError: e.toString()));
      }
    });
    on<LoadDailyTaskEvent>((event, emit) async {
      emit(DailyTaskLoading());
      try {
        final tasks = await getDailyTask(event.day);

        final filteredTasks = tasks
            .where((task) =>
                task.startTime.year == event.day.year &&
                task.startTime.month == event.day.month &&
                task.startTime.day == event.day.day)
            .toList();

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

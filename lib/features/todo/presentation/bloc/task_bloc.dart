import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/add_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/delete_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/get_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/update_task.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_event.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTask getTask;
  final AddTask addTask;
  final DeleteTask deleteTask;
  final UpdateTask updateTask;

  TaskBloc(this.getTask, this.addTask, this.deleteTask, this.updateTask)
      : super(TaskEmptyState()) {
    on<TaskAddEvent>((event, emit) async {
      emit(TaskAddState());
      try {
        await addTask(event.task);

        // После добавления сразу получить все таски и перезалить их
        final tasks = await getTask(event.task.date);

        final filteredTasks = tasks
            .where((task) =>
                task.date.year == event.task.date.year &&
                task.date.month == event.task.date.month &&
                task.date.day == event.task.date.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });

        emit(TaskLoadedState(taskList: filteredTasks)); // перезаписываем список
      } catch (e) {
        emit(TaskErrorState(taskError: e.toString()));
      }
    });

    on<TaskUpdatingEvent>((event, emit) async {
      emit(TaskUpdatingState());
      try {
        await updateTask(event.task);

        final tasks = await getTask(event.task.date);

        final filteredTasks = tasks
            .where((task) =>
                task.date.year == event.task.date.year &&
                task.date.month == event.task.date.month &&
                task.date.day == event.task.date.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });

        emit(TaskLoadedState(taskList: filteredTasks));
      } catch (e) {
        emit(TaskErrorState(taskError: e.toString()));
      }
    });

    on<TaskDeleteEvent>((event, emit) async {
      emit(TaskDeleteState());
      try {
        await deleteTask(event.task);

        final tasks = await getTask(event.task.date);

        final filteredTasks = tasks
            .where((task) =>
                task.date.year == event.task.date.year &&
                task.date.month == event.task.date.month &&
                task.date.day == event.task.date.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });

        emit(TaskLoadedState(taskList: filteredTasks)); // ПЕРЕЗАПИСЫВАЕМ СПИСОК
      } catch (e) {
        emit(TaskErrorState(taskError: e.toString()));
      }
    });

    on<TaskGetEvent>((event, emit) async {
      emit(TaskLoadingState());
      try {
        final tasks = await getTask(event.day);

        final filteredTasks = tasks
            .where((task) =>
                task.date.year == event.day.year &&
                task.date.month == event.day.month &&
                task.date.day == event.day.day)
            .toList();

        filteredTasks.sort((a, b) {
          if (a.isDone == b.isDone) return 0;
          return a.isDone ? 1 : -1;
        });

        emit(TaskLoadedState(taskList: filteredTasks));
      } catch (e) {
        emit(TaskErrorState(taskError: e.toString()));
      }
    });
  }
}

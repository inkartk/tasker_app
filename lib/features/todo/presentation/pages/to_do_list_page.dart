import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_event.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_state.dart';
import 'package:my_the_best_project/features/todo/presentation/widgets/bottom_sheet.dart';
import 'package:my_the_best_project/features/todo/presentation/widgets/calendar.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController controller = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Daily Task'),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                size: 30,
              )),
          actions: [
            IconButton(
              onPressed: () {
                context.go('/to_do_week');
              },
              icon: const Icon(
                Icons.menu,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
                showAddTaskSheet(context);
              },
              icon: const Icon(
                Icons.add_circle_outline,
                size: 30,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            ToDoCalendar(
              startDate: DateTime.now(),
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                context.read<TaskBloc>().add(TaskGetEvent(day: date));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<TaskBloc, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoadingState ||
                      state is TaskAddState ||
                      state is TaskDeleteState ||
                      state is TaskUpdatingState) {
                    return const Center(child: Text(''));
                  }
                  if (state is TaskErrorState) {
                    return Center(child: Text('Ошибка: ${state.taskError}'));
                  }

                  final filteredTasks =
                      (state is TaskLoadedState) ? state.taskList : [];

                  if (filteredTasks.isEmpty) {
                    return const Center(child: Text('No tasks'));
                  }

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return Dismissible(
                        key: ValueKey(task.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.redAccent,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          context
                              .read<TaskBloc>()
                              .add(TaskDeleteEvent(task: task));
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          trailing: Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                              shape: const CircleBorder(),
                              activeColor: Colors.blue,
                              value: task.isDone,
                              onChanged: (value) {
                                context.read<TaskBloc>().add(
                                      TaskUpdatingEvent(
                                        task: task.copyWith(
                                            isDone: value ?? false),
                                      ),
                                    );
                              },
                            ),
                          ),
                          leading: Text(
                            '${index + 1}.',
                            style: TextStyle(
                              fontSize: 18,
                              color: task.isDone ? Colors.grey : Colors.black,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              color: task.isDone ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  void showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddTaskBottomSheet(selectedDate: selectedDate),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/to_do_list/models/to_do_week_model.dart';
import 'package:my_the_best_project/features/to_do_list/widgets/week_calendar.dart';

class ToDoWeek extends StatefulWidget {
  const ToDoWeek({super.key});

  @override
  State<ToDoWeek> createState() => _ToDoWeekState();
}

class _ToDoWeekState extends State<ToDoWeek> {
  final TextEditingController controller = TextEditingController();
  List<TaskWeek> tasks = [];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final filteredTasks = tasks
        .where((task) =>
            task.date.year == selectedDate.year &&
            task.date.month == selectedDate.month &&
            task.date.day == selectedDate.day)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Weekly Task'),
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 30,
            )),
        actions: [
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
          WeekCalendar(
            startDate: DateTime.now(),
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];

                return Dismissible(
                  key: ValueKey(task.title),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      tasks.remove(task); // удаляем из общего списка
                    });
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    trailing: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                        shape: const CircleBorder(),
                        activeColor: Colors.blue,
                        value: task.isDone,
                        onChanged: (value) {
                          setState(() {
                            task.isDone = value!;
                            tasks.sort((a, b) {
                              if (a.isDone == b.isDone) return 0;
                              return a.isDone ? 1 : -1;
                            });
                          });
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
            ),
          ),
        ],
      ),
    );
  }

  void showAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '📝 Add New Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter task...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final text = controller.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      tasks.add(TaskWeek(title: text, date: selectedDate));
                    });
                    controller.clear();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Add Task'),
              ),
            ],
          ),
        );
      },
    );
  }
}

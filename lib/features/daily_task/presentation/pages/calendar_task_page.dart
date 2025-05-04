import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_state.dart';
import 'package:my_the_best_project/features/daily_task/presentation/widgets/calendar.dart';

class CalendarTaskPage extends StatefulWidget {
  const CalendarTaskPage({super.key});
  @override
  State<CalendarTaskPage> createState() => _CalendarTaskPageState();
}

class _CalendarTaskPageState extends State<CalendarTaskPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DailyTaskBloc>().add(LoadDailyTaskEvent(day: _selectedDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.calendar_today, color: Color(0xFF105CDB)),
          title: Text(
            DateFormat('MMM, yyyy').format(_selectedDate),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF105CDB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () => context.go('/add_task'),
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                label: const Text('Add Task',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Календарь
            ToDoCalendar(
              startDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                context
                    .read<DailyTaskBloc>()
                    .add(LoadDailyTaskEvent(day: date));
              },
            ),
            const SizedBox(height: 16),
            const TabBar(
              indicatorColor: Color(0xFF105CDB),
              labelColor: Color(0xFF105CDB),
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              tabs: [
                Tab(text: 'Priority Task'),
                Tab(text: 'Daily Task'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<DailyTaskBloc, DailyTaskState>(
                builder: (context, state) {
                  if (state is DailyTaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is DailyTaskLoaded) {
                    final priority = state.dailyTaskList
                        .where((t) => t.category == 'Priority Task')
                        .toList();
                    final daily = state.dailyTaskList
                        .where((t) => t.category == 'Daily Task')
                        .toList();

                    return TabBarView(
                      children: [
                        // ===== Priority Task View =====
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: priority.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            final t = priority[i];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade100,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 4,
                                        height: 40,
                                        color: const Color(0xFF105CDB),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          t.title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.more_horiz),
                                        onPressed: () {
                                          context.go('/edit_task', extra: t);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    t.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${DateFormat('MMM d').format(t.startTime)} - ${DateFormat('MMM d').format(t.endTime)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF105CDB),
                                    ),
                                  ),

                                  // ==== показываем подзадачи ====
                                  if (t.subTasks.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    const Text('Sub-tasks:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 6),
                                    ...t.subTasks.map((s) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Text(
                                            '• $s',
                                            style: const TextStyle(
                                                color: Colors.black87),
                                          ),
                                        )),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),

                        // ===== Daily Task View =====
                        ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: daily.length,
                          itemBuilder: (context, i) {
                            final t = daily[i];
                            return GestureDetector(
                              onTap: () {
                                context.go('/edit_task', extra: t);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade100,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  t.title,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  if (state is DailyTaskErrorState) {
                    return Center(child: Text(state.dailyTaskError));
                  }
                  return const Center(child: Text('Нет задач на этот день'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_state.dart';

const _primaryColor = Color(0xFF105CDB);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DateTime _startDate = DateTime.now();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    context
        .read<DailyTaskBloc>()
        .add(LoadDailyTaskEvent(userID: uid, day: _startDate));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<DailyTaskBloc, DailyTaskState>(
          builder: (context, state) {
            if (state is DailyTaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DailyTaskLoaded) {
              final priorityList = state.dailyTaskList
                  .where((t) => t.category == 'Priority Task')
                  .toList();
              final dailyList = state.dailyTaskList
                  .where((t) => t.category == 'Daily Task')
                  .toList();

              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('EEEE, MMM d yyyy').format(_startDate),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                        ),
                        const Spacer(),
                        const Icon(Icons.notifications, color: _primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Welcome, ${user?.displayName ?? 'User'}',
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Have a nice day !',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'My Priority Task',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(left: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: priorityList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final t = priorityList[index];
                        final total = t.endTime
                            .difference(t.startTime)
                            .inSeconds
                            .toDouble();
                        final passed = DateTime.now()
                            .difference(t.startTime)
                            .inSeconds
                            .toDouble();
                        final totalTasks = t.subTasks.length;
                        final doneTasks =
                            t.subTasks.where((sub) => sub.isDone).length;
                        final progress = totalTasks > 0
                            ? (doneTasks / totalTasks).clamp(0.0, 1.0)
                            : t.isDone
                                ? 1.0
                                : 0.0;

                        final now = DateTime.now();

                        final inclusiveEndOfDay = DateTime(
                          t.endTime.year,
                          t.endTime.month,
                          t.endTime.day,
                          23,
                          59,
                          59,
                          999,
                        );

                        final diff = inclusiveEndOfDay.difference(now);

                        final daysLeft =
                            diff.isNegative ? '1 days' : '${diff.inDays} days';

                        final gradients = [
                          [const Color(0xFF3A8DFF), const Color(0xFF0077FF)],
                          [const Color(0xFF4E0080), const Color(0xFF2E003F)],
                          [const Color(0xFFFF4E42), const Color(0xFF9E1E1A)],
                        ];
                        final colors = gradients[index % gradients.length];
                        return GestureDetector(
                          onTap: () => context.go('/priority_page', extra: t),
                          child: PriorityTaskCard(
                            icon: Icons.star,
                            title: t.title,
                            daysLeft: daysLeft,
                            progress: progress,
                            gradientColors: colors,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Daily Task',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...dailyList.map((t) {
                    return GestureDetector(
                      onTap: () => context.go('/daily_page', extra: t),
                      child: DailyTaskTile(
                        title: t.title,
                        isDone: t.isDone,
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
              );
            } else if (state is DailyTaskErrorState) {
              return Center(child: Text(state.dailyTaskError));
            } else {
              return const Center(child: Text('Нет задач на выбранный день'));
            }
          },
        ),
      ),
    );
  }
}

class PriorityTaskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String daysLeft;
  final double progress;
  final List<Color> gradientColors;

  const PriorityTaskCard({
    super.key,
    required this.icon,
    required this.title,
    required this.daysLeft,
    required this.progress,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  daysLeft,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 32, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Progress',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DailyTaskTile extends StatelessWidget {
  final String title;
  final bool isDone;

  const DailyTaskTile({
    super.key,
    required this.title,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDone ? const Color(0xFF006EE9) : Colors.black87,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? const Color(0xFF006EE9) : Colors.transparent,
              border: Border.all(
                color: const Color(0xFF006EE9),
                width: 2,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}

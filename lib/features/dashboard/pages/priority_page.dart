import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/dashboard/bloc/detail_priority_bloc.dart';

import '../../daily_task/domain/entity/daily_task.dart';
import '../../daily_task/domain/entity/subtasks.dart';

class PriorityPage extends StatelessWidget {
  final DailyTask initialTask;
  const PriorityPage({super.key, required this.initialTask});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<DetailPriorityTaskCubit>(
        create: (_) => sl<DetailPriorityTaskCubit>(param1: initialTask),
        child: _PriorityView(),
      ),
    );
  }
}

class _PriorityView extends StatelessWidget {
  _PriorityView({super.key});

  static const _primaryColor = Color(0xFF006EE9);
  static const _backgroundColor = Colors.white;
  static const _cardRadius = BorderRadius.all(Radius.circular(16));
  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  String _formatDate(DateTime d) => _dateFormat.format(d);
  final DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
    );

    return Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: _cardRadius,
              ),
              padding: const EdgeInsets.all(16),
              child:
                  BlocBuilder<DetailPriorityTaskCubit, DetailPriorityTaskState>(
                builder: (context, state) {
                  final t = state.task;
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

                  final daysLeft = diff.isNegative ? 0 : diff.inDays;

                  final hoursLeft =
                      diff.isNegative ? 0 : diff.inHours - daysLeft * 24;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, theme, t.title),
                        const SizedBox(height: 24),
                        _buildDateRow(theme, t.startTime, t.endTime),
                        const SizedBox(height: 24),
                        _buildTimeCards(daysLeft, hoursLeft),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Description', theme),
                        const SizedBox(height: 8),
                        Text(t.description, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 24),
                        if (t.subTasks.isNotEmpty) ...[
                          _buildSectionTitle('Progress', theme),
                          const SizedBox(height: 8),
                          _buildProgressBar(state.progress),
                          const SizedBox(height: 24),
                          _buildSectionTitle('To do List', theme),
                          const SizedBox(height: 8),
                          _buildSubTasksList(context, t.subTasks),
                        ],
                        if (t.subTasks.isEmpty) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: t.isDone
                                  ? null
                                  : () {
                                      final updated = t.copyWith(isDone: true);
                                      context.read<DailyTaskBloc>().add(
                                          EditDailyTaskEvent(
                                              dailyTask: updated));
                                      context.go('/main?tab=0');
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _primaryColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                t.isDone ? 'Finished' : 'Finish',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ]);
                },
              ),
            ),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, String title) {
    return Row(
      children: [
        const Icon(Icons.public, color: _primaryColor, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge!
                .copyWith(color: _primaryColor, fontWeight: FontWeight.w700),
          ),
        ),
        InkWell(
          onTap: () => context.go('/main?tab=0'),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(ThemeData theme, DateTime start, DateTime end) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DateLabel(
          label: 'start',
          value: _formatDate(start),
          textTheme: theme.textTheme,
        ),
        _DateLabel(
          label: 'end',
          value: _formatDate(end),
          textTheme: theme.textTheme,
          alignEnd: true,
        ),
      ],
    );
  }

  Widget _buildTimeCards(int days, int hours) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TimeCard(value: days.toString(), label: 'days'),
        const SizedBox(width: 12),
        _TimeCard(value: hours.toString(), label: 'hours'),
      ],
    );
  }

  Widget _buildSectionTitle(String text, ThemeData theme) {
    return Text(
      text,
      style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
    );
  }

  Widget _buildProgressBar(double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        minHeight: 8,
        value: progress,
        backgroundColor: Colors.grey.shade300,
        color: _primaryColor,
      ),
    );
  }

  Widget _buildSubTasksList(BuildContext context, List<SubTask> subs) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: subs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) {
        final sub = subs[i];
        return InkWell(
          onTap: () => context.read<DetailPriorityTaskCubit>().toggleSubTask(i),
          borderRadius: _cardRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200, width: 2),
              borderRadius: _cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sub.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          sub.isDone ? const Color(0xFF006EE9) : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: sub.isDone
                        ? const Color(0xFF006EE9)
                        : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFF006EE9),
                      width: 2,
                    ),
                  ),
                  child: sub.isDone
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DateLabel extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme textTheme;
  final bool alignEnd;

  const _DateLabel({
    super.key,
    required this.label,
    required this.value,
    required this.textTheme,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _TimeCard extends StatelessWidget {
  final String value;
  final String label;
  const _TimeCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        color: const Color(0xFF006EE9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }
}

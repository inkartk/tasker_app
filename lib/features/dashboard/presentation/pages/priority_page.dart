import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/dashboard/presentation/bloc/detail_priority_bloc.dart';

import '../../../daily_task/domain/entity/daily_task.dart';
import '../../../daily_task/domain/entity/subtasks.dart';

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

  static const _primaryColor = Color(0xFF3366FF);
  static const _backgroundColor = Color(0xFFF2F4F7);
  static const _cardRadius = BorderRadius.all(Radius.circular(16));
  final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  String _formatDate(DateTime d) => _dateFormat.format(d);

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Заголовок + кнопка закрыть
                      _buildHeader(context, theme, t.title),

                      const SizedBox(height: 24),
                      // Даты
                      _buildDateRow(theme, t.startTime, t.endTime),

                      const SizedBox(height: 24),
                      // Тайм-карточки
                      _buildTimeCards(state.months, state.days, state.hours),

                      const SizedBox(height: 24),
                      // Описание
                      _buildSectionTitle('Description', theme),
                      const SizedBox(height: 8),
                      Text(t.description, style: theme.textTheme.bodyMedium),

                      const SizedBox(height: 24),
                      // Прогресс
                      _buildSectionTitle('Progress', theme),
                      const SizedBox(height: 8),
                      _buildProgressBar(state.progress),

                      const SizedBox(height: 24),
                      // Список подзадач
                      _buildSectionTitle('To do List', theme),
                      const SizedBox(height: 8),
                      _buildSubTasksList(context, t.subTasks),
                    ],
                  );
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
          onTap: () => GoRouter.of(context).go('/main'),
          borderRadius: _cardRadius,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: _primaryColor),
              borderRadius: _cardRadius,
            ),
            child: const Icon(Icons.close, size: 20, color: _primaryColor),
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

  Widget _buildTimeCards(int months, int days, int hours) {
    return Row(
      children: [
        _TimeCard(value: months.toString(), label: 'months'),
        const SizedBox(width: 12),
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
              border: Border.all(
                  color: sub.isDone ? _primaryColor : Colors.grey.shade200,
                  width: 1.5),
              borderRadius: _cardRadius,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    sub.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          sub.isDone ? FontWeight.w500 : FontWeight.w600,
                      color: sub.isDone ? _primaryColor : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  sub.isDone
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: sub.isDone ? _primaryColor : Colors.grey.shade400,
                  size: 20,
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
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF105CDB),
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
      ),
    );
  }
}

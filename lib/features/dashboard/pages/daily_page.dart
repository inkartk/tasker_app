import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/dashboard/widgets/detail_widgets.dart';

const _primaryColor = Color(0xFF006EE9);

class DailyTaskDetailPage extends StatefulWidget {
  final DailyTask task;
  const DailyTaskDetailPage({super.key, required this.task});

  @override
  State<DailyTaskDetailPage> createState() => _DailyTaskDetailPageState();
}

class _DailyTaskDetailPageState extends State<DailyTaskDetailPage> {
  late Timer _timer;

  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final now = DateTime.now();
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59);
    final diff = endOfDay.difference(now);
    setState(() {
      _remaining = diff.isNegative ? Duration.zero : diff;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.fitness_center,
                      color: _primaryColor, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
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
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Dates
              Row(
                children: [
                  DateColumn(
                      label: 'start',
                      value: DateFormat('d MMM yyyy')
                          .format(widget.task.startTime)),
                  const Spacer(),
                  DateColumn(
                      label: 'end',
                      value:
                          DateFormat('d MMM yyyy').format(widget.task.endTime)),
                ],
              ),

              const SizedBox(height: 24),

              // Countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimeBox(value: '$hours', label: 'hours'),
                  const SizedBox(width: 16),
                  TimeBox(value: '$minutes', label: 'minutes'),
                ],
              ),

              const SizedBox(height: 32),

              // Description
              const Text(
                'Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                widget.task.description,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black87, height: 1.4),
              ),

              const SizedBox(height: 32),

              // Finish button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.task.isDone
                      ? null
                      : () {
                          // mark as done
                          final updated = widget.task.copyWith(isDone: true);
                          context
                              .read<DailyTaskBloc>()
                              .add(EditDailyTaskEvent(dailyTask: updated));
                          context.go('/main?tab=0');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.task.isDone ? 'Finished' : 'Finish',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

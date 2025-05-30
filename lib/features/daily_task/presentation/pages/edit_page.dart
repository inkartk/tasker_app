import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/subtasks.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_state.dart';

class EditTaskPage extends StatefulWidget {
  final DailyTask task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _selectedCategory;

  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final List<TextEditingController> _subControllers = [];
  final List<bool> _subDone = [];

  @override
  void initState() {
    super.initState();

    final t = widget.task;
    _startDate = t.startTime;
    _endDate = t.endTime;
    _selectedCategory = t.category == 'Priority Task' ? 0 : 1;

    _titleController.text = t.title;
    _descController.text = t.description;

    if (t.subTasks.isNotEmpty) {
      for (var sub in t.subTasks) {
        _subControllers.add(TextEditingController(text: sub.title));
        _subDone.add(sub.isDone);
      }
    } else {
      _subControllers.add(TextEditingController());
      _subDone.add(false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    for (var c in _subControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(BuildContext ctx, bool isStart) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: ctx,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) _endDate = _startDate;
        } else {
          _endDate = picked;
          if (_startDate.isAfter(_endDate)) _startDate = _endDate;
        }
      });
    }
  }

  Widget _buildDateField(String label, DateTime date, VoidCallback onTap) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Color(0xFF105CDB),
                  ),
                  const SizedBox(width: 8),
                  Text(DateFormat('MMM d, yyyy').format(date),
                      style: const TextStyle(fontSize: 14)),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryToggle() {
    return Row(
      children: [
        Expanded(child: _buildCategoryButton('Priority Task', 0)),
        const SizedBox(width: 16),
        Expanded(child: _buildCategoryButton('Daily Task', 1)),
      ],
    );
  }

  Widget _buildCategoryButton(String text, int idx) {
    final isSel = _selectedCategory == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = idx),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF105CDB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF105CDB),
          ),
        ),
        alignment: Alignment.center,
        child: Text(text,
            style: TextStyle(
              color: isSel ? Colors.white : const Color(0xFF105CDB),
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  void _onSavePressed() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    final subs = <SubTask>[];
    for (var i = 0; i < _subControllers.length; i++) {
      final text = _subControllers[i].text.trim();
      if (text.isEmpty) continue;

      final doneFlag = _subDone[i];

      if (i < widget.task.subTasks.length) {
        final original = widget.task.subTasks[i];
        subs.add(
          original.copyWith(
            title: text,
            isDone: doneFlag,
          ),
        );
      } else {
        subs.add(
          SubTask(
            title: text,
            isDone: doneFlag,
          ),
        );
      }
    }

    final updated = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      startTime: _startDate,
      endTime: _endDate,
      category: _selectedCategory == 0 ? 'Priority Task' : 'Daily Task',
      subTasks: subs,
    );

    context.read<DailyTaskBloc>().add(EditDailyTaskEvent(dailyTask: updated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF105CDB),
      appBar: AppBar(
        title: const Text('Edit Task',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: const Color(0xFF105CDB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.go('/main?tab=1'),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.task_alt,
                            size: 28, color: Color(0xFF105CDB)),
                        const SizedBox(width: 8),
                        Text(
                          _titleController.text,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF105CDB),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(children: [
                      _buildDateField(
                          'Start', _startDate, () => _pickDate(context, true)),
                      const SizedBox(width: 16),
                      _buildDateField(
                          'Ends', _endDate, () => _pickDate(context, false)),
                    ]),
                    const SizedBox(height: 24),
                    const Text('Title',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF105CDB),
                        )),
                    TextField(
                      controller: _titleController,
                      decoration: _inputDecoration(''),
                    ),
                    const SizedBox(height: 24),
                    const Text('Category',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF105CDB),
                        )),
                    const SizedBox(height: 6),
                    _buildCategoryToggle(),
                    const SizedBox(height: 24),
                    const Text('Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF105CDB),
                        )),
                    TextField(
                      controller: _descController,
                      decoration: _inputDecoration(''),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    if (_selectedCategory == 0) ...[
                      const Text('To do list',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF105CDB),
                          )),
                      const SizedBox(height: 12),
                      ..._subControllers.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ctrl = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(children: [
                            Expanded(
                              child: TextField(
                                controller: ctrl,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_subControllers.length > 1)
                              GestureDetector(
                                onTap: () => setState(() {
                                  _subControllers.removeAt(i).dispose();
                                }),
                                child: const Icon(Icons.close,
                                    color: Colors.redAccent),
                              ),
                          ]),
                        );
                      }),
                      IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () => setState(() {
                          _subControllers.add(TextEditingController());
                          _subDone.add(false);
                        }),
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF105CDB),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    BlocConsumer<DailyTaskBloc, DailyTaskState>(
                      listener: (ctx, state) {
                        if (state is DailyTaskLoaded) {
                          context.go('/main?tab=1');
                        }
                        if (state is DailyTaskErrorState) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(content: Text(state.dailyTaskError)),
                          );
                        }
                      },
                      builder: (ctx, state) {
                        final loading = state is DailyTaskLoading;
                        return ElevatedButton(
                          onPressed: loading ? null : _onSavePressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF105CDB),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text(
                                  'Save Task',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

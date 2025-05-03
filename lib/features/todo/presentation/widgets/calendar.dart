import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoCalendar extends StatefulWidget {
  final DateTime startDate;
  final Function(DateTime) onDateSelected;

  const ToDoCalendar({
    super.key,
    required this.startDate,
    required this.onDateSelected,
  });

  @override
  State<ToDoCalendar> createState() => _ToDoCalendarState();
}

class _ToDoCalendarState extends State<ToDoCalendar> {
  late PageController _pageController;
  late DateTime selectedDate;
  final int totalWeeks = 100;
  final int initialPage = 50;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.startDate;
    _pageController = PageController(initialPage: initialPage);
    _pageController.addListener(_onPageScroll);
  }

  void _onPageScroll() {
    final page = _pageController.page;
    if (page == null) return;
    final weekOffset = page.toInt() - initialPage;
    final monday = getWeekDays(weekOffset).first;
    if (!_isSameDay(selectedDate, monday)) {
      setState(() => selectedDate = monday);
      widget.onDateSelected(monday);
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  void dispose() {
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  List<DateTime> getWeekDays(int weekOffset) {
    final startOfWeek = widget.startDate
        .subtract(Duration(days: widget.startDate.weekday - 1))
        .add(Duration(days: weekOffset * 7));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemCount: totalWeeks,
        itemBuilder: (context, index) {
          final weekOffset = index - initialPage;
          final days = getWeekDays(weekOffset);
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: days.map((date) {
              final isSelected = _isSameDay(selectedDate, date);
              return GestureDetector(
                onTap: () {
                  setState(() => selectedDate = date);
                  widget.onDateSelected(date);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  height: isSelected ? 70 : 60,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF105CDB)
                        : const Color(0xFF105CDB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF105CDB).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

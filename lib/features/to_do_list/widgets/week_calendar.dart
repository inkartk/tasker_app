import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendar extends StatefulWidget {
  final DateTime startDate;
  final Function(DateTime) onDateSelected;

  const WeekCalendar({
    super.key,
    required this.startDate,
    required this.onDateSelected,
  });

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late PageController _pageController;
  late DateTime selectedDate;
  final int totalWeeks = 100;
  final int initialPage = 50;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.startDate;
    _pageController = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
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
      height: 70,
      child: PageView.builder(
        controller: _pageController,
        itemCount: totalWeeks,
        itemBuilder: (context, index) {
          final weekOffset = index - initialPage;
          final weekDays = getWeekDays(weekOffset);

          final monday =
              weekDays.firstWhere((d) => d.weekday == DateTime.monday);
          final sunday =
              weekDays.firstWhere((d) => d.weekday == DateTime.sunday);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDayWidget(monday),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_back_rounded, size: 16),
              const Icon(Icons.arrow_forward_rounded, size: 16),
              const SizedBox(width: 12),
              _buildDayWidget(sunday),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDayWidget(DateTime date) {
    final isSelected = selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = date;
        });
        widget.onDateSelected(date);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat.E().format(date).toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

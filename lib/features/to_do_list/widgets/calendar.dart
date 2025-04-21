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
  final int initialPage = 50; // середина — текущая неделя

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

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: weekDays.map((date) {
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blueAccent : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.E().format(date).toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
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

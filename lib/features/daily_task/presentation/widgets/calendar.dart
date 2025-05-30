import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoCalendar extends StatefulWidget {
  final DateTime startDate;

  final ValueChanged<DateTime> onDateSelected;

  const ToDoCalendar({
    super.key,
    required this.startDate,
    required this.onDateSelected,
  });

  @override
  State<ToDoCalendar> createState() => _ToDoCalendarState();
}

class _ToDoCalendarState extends State<ToDoCalendar> {
  static final _refDate = DateTime(2000, 1, 1);

  static const _visibleDays = 7;

  late final PageController _pageController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.startDate;

    final initialPage = widget.startDate.difference(_refDate).inDays;

    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 1 / _visibleDays,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected(_selectedDate);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            final newDate = _refDate.add(Duration(days: index));
            setState(() => _selectedDate = newDate);
            widget.onDateSelected(newDate);
          },
          itemBuilder: (context, index) {
            final date = _refDate.add(Duration(days: index));
            final isSelected = _isSameDay(date, _selectedDate);

            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              },
              child: AnimatedContainer(
                width: isSelected ? 64 : 50,
                duration: const Duration(milliseconds: 200),
                height: isSelected ? 64 : 50,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF105CDB)
                      : const Color(0xFF105CDB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E().format(date),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF105CDB)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF105CDB)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

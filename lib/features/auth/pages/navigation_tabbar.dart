import 'package:flutter/material.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/calendar_task_page.dart';
import 'package:my_the_best_project/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:my_the_best_project/features/profile/pages/account_page.dart';

class NavigationTabBar extends StatefulWidget {
  final int initialIndex;

  const NavigationTabBar({super.key, this.initialIndex = 2});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  late int _selectedIndex;

  final List<Widget> _pages = const [
    DashboardPage(),
    CalendarTaskPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'To Do List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'AI Chat',
          ),
        ],
      ),
    );
  }
}

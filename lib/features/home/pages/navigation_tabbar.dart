import 'package:flutter/material.dart';
import 'package:my_the_best_project/features/home/pages/calendar_task_page.dart';
import 'package:my_the_best_project/features/home/tabbar_pages/ai_chat_page.dart';
import 'package:my_the_best_project/features/todo/presentation/pages/to_do_list_page.dart';

class NavigationTabBar extends StatefulWidget {
  const NavigationTabBar({super.key});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const ToDoList(),
    const CalendarTaskPage(),
    const AiChatPage(),
  ];

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

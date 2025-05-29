import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/calendar_task_page.dart';
import 'package:my_the_best_project/features/dashboard/pages/dashboard_page.dart';
import 'package:my_the_best_project/features/profile/pages/account_page.dart';
import 'package:my_the_best_project/gen/assets.gen.dart';

class NavigationTabBar extends StatefulWidget {
  final int initialIndex;

  const NavigationTabBar({super.key, this.initialIndex = 2});

  @override
  State<NavigationTabBar> createState() => _NavigationTabBarState();
}

class _NavigationTabBarState extends State<NavigationTabBar> {
  late int _selectedIndex;

  static const _selectedColor = Color(0xFF3366FF);
  static const _unselectedColor = Color(0xFFABCEF5);

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

  BottomNavigationBarItem _buildItem(String assetPath) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        assetPath,
        width: 32,
        height: 32,
        color: _unselectedColor,
      ),
      activeIcon: SvgPicture.asset(
        assetPath,
        width: 32,
        height: 32,
        color: _selectedColor,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          _buildItem(Assets.icons.home),
          _buildItem(Assets.icons.calendar),
          _buildItem(Assets.icons.person),
        ],
      ),
    );
  }
}

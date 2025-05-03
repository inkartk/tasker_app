import 'package:flutter/material.dart';
import 'package:my_the_best_project/features/todo/presentation/widgets/calendar.dart';

class CalendarTaskPage extends StatelessWidget {
  const CalendarTaskPage({super.key});

  // Пример данных для Priority Task
  final List<Map<String, dynamic>> _priorityTasks = const [
    {
      'icon': Icons.public,
      'title': 'UI Design',
      'description':
          'User interface (UI) design is the process designers use to build interfaces in software or computerized devices, focusing on looks or style...',
      'dateRange': 'Feb, 21 - Mar, 12',
    },
    {
      'icon': Icons.code,
      'title': 'Laravel Task',
      'description':
          'Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable...',
      'dateRange': 'Feb, 21 - Mar, 22',
    },
    {
      'icon': Icons.image,
      'title': 'Edit a Picture',
      'description':
          'Image editing encompasses the processes of altering images, applying filters, and retouching photographs to enhance them...',
      'dateRange': 'Feb, 21 - Mar, 18',
    },
  ];

  // Пример данных для Daily Task
  final List<String> _dailyTasks = const [
    'Work Out',
    'Daily Meeting',
    'Reading Book',
    'Learn Coding',
    'Sleep soon',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const Icon(Icons.calendar_today, color: Color(0xFF105CDB)),
          title: const Text(
            'Feb, 2022',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF105CDB),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                onPressed: () {
                  // TODO: открыть BottomSheet или навигацию
                },
                icon: const Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                ),
                label: const Text('Add Task',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // --- Календарь (ваш ToDoCalendar) ---
            ToDoCalendar(
              startDate: DateTime.now(),
              onDateSelected: (date) {
                // TODO: загрузить таски на выбранную дату
              },
            ),

            const SizedBox(height: 16),

            // --- TabBar: Priority / Daily ---
            const TabBar(
              indicatorColor: Colors.blueAccent,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 16),
              tabs: [
                Tab(text: 'Priority Task'),
                Tab(text: 'Daily Task'),
              ],
            ),

            const SizedBox(height: 8),

            // --- Контент вкладок ---
            Expanded(
              child: TabBarView(
                children: [
                  // Вкладка Priority
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _priorityTasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final task = _priorityTasks[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Акцентная полоска слева
                            Container(
                              width: 4,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFF105CDB),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Содержимое карточки
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(task['icon'],
                                            color: const Color(0xFF105CDB)),
                                        const SizedBox(width: 8),
                                        Text(
                                          task['title'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.more_horiz,
                                            color: Colors.grey),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      task['description'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        task['dateRange'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF105CDB),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Вкладка Daily
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _dailyTasks.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          _dailyTasks[index],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

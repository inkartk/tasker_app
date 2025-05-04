import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/register_page.dart';
import 'package:my_the_best_project/features/auth/pages/reset_password.dart';
import 'package:my_the_best_project/features/auth/pages/verify_code.dart';
import 'package:my_the_best_project/features/auth/widgets/firebase_stream.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/add_task_page.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/calendar_task_page.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/edit_page.dart';
import 'package:my_the_best_project/features/home/pages/account_page.dart';
import 'package:my_the_best_project/features/home/pages/navigation_tabbar.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const FirebaseStream(),
    ),
    GoRoute(path: '/reset-email', builder: (_, __) => const ResetPassword()),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountPage(),
    ),
    GoRoute(
      path: '/add_task',
      builder: (context, state) => const AddTaskPage(),
    ),
    GoRoute(
      path: '/edit_task',
      builder: (context, state) {
        // ожидаем, что вы передаёте туда DailyTask через extra:
        final task = state.extra;
        if (task is! DailyTask) {
          // на всякий случай — если кто-то зашёл без передачи extra
          return const Scaffold(
            body: Center(child: Text('Error: no task provided')),
          );
        }
        return EditTaskPage(task: task);
      },
    ),
    GoRoute(
      path: '/calendar_page',
      builder: (context, state) => const CalendarTaskPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const NavigationTabBar(),
    ),
    GoRoute(
      path: '/verify-code',
      builder: (_, state) {
        final data = state.extra as Map<String, String>;
        return VerifyCodePage(
          email: data['email']!,
          password: data['password']!,
          displayName: data['name']!,
        );
      },
    ),
  ],
);

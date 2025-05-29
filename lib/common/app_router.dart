import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/navigation_tabbar.dart';
import 'package:my_the_best_project/features/auth/pages/register_page.dart';
import 'package:my_the_best_project/features/auth/pages/reset_password.dart';
import 'package:my_the_best_project/features/auth/pages/verify_code.dart';
import 'package:my_the_best_project/features/auth/widgets/firebase_stream.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/add_task_page.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/calendar_task_page.dart';
import 'package:my_the_best_project/features/daily_task/presentation/pages/edit_page.dart';
import 'package:my_the_best_project/features/dashboard/presentation/bloc/detail_priority_bloc.dart';
import 'package:my_the_best_project/features/dashboard/presentation/pages/daily_page.dart';
import 'package:my_the_best_project/features/dashboard/presentation/pages/priority_page.dart';
import 'package:my_the_best_project/features/profile/pages/account_page.dart';
import 'package:my_the_best_project/features/profile/pages/profile_page.dart';

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
        final task = state.extra;
        if (task is! DailyTask) {
          return const Scaffold(
            body: Center(child: Text('Error: no task provided')),
          );
        }
        return EditTaskPage(task: task);
      },
    ),
    GoRoute(
      path: '/priority_page',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is! DailyTask) {
          return const Scaffold(
            body: Center(child: Text('Error: no task provided')),
          );
        }
        final task = extra;
        return BlocProvider<DetailPriorityTaskCubit>(
          create: (_) => sl<DetailPriorityTaskCubit>(
            param1: task,
          ),
          child: PriorityPage(initialTask: task),
        );
      },
    ),
    GoRoute(
      path: '/daily_page',
      builder: (context, state) {
        final task = state.extra;
        if (task is! DailyTask) {
          return const Scaffold(
            body: Center(child: Text('Error: no task provided')),
          );
        }
        return DailyTaskDetailPage(task: task);
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
      name: 'main',
      pageBuilder: (context, state) {
        final index = int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0;
        return MaterialPage(
          child: NavigationTabBar(initialIndex: index),
        );
      },
    ),
    GoRoute(
      path: '/profile_page',
      builder: (_, __) => const ProfilePage(),
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

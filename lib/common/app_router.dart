import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/register_page.dart';
import 'package:my_the_best_project/features/auth/pages/reset_password.dart';
import 'package:my_the_best_project/features/auth/pages/verify_email.dart';
import 'package:my_the_best_project/features/home/pages/account_page.dart';
import 'package:my_the_best_project/features/home/pages/navigation_tabbar.dart';
import 'package:my_the_best_project/features/to_do_week/to_do_week.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_event.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const FirebaseStream(),
    // ),
    GoRoute(
      path: '/reset_password',
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: '/to_do_week',
      builder: (context, state) => const ToDoWeek(),
    ),
    GoRoute(
      path: '/account',
      builder: (context, state) => const AccountPage(),
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
      path: '/',
      builder: (context, state) {
        return BlocProvider<TaskBloc>(
          create: (context) =>
              sl<TaskBloc>()..add(TaskGetEvent(day: DateTime.now())),
          child: const NavigationTabBar(),
        );
      },
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) => const VerifyEmail(),
    ),
  ],
);

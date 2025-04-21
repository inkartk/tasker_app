import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/register_page.dart';
import 'package:my_the_best_project/features/auth/pages/reset_password.dart';
import 'package:my_the_best_project/features/auth/pages/verify_email.dart';
import 'package:my_the_best_project/features/home/pages/account_page.dart';
import 'package:my_the_best_project/features/home/pages/navigation_tabbar.dart';
import 'package:my_the_best_project/features/to_do_list/pages/to_do_week.dart';

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
      builder: (context, state) => const NavigationTabBar(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) => const VerifyEmail(),
    ),
  ],
);

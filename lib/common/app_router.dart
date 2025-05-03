import 'package:go_router/go_router.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/register_page.dart';
import 'package:my_the_best_project/features/auth/pages/reset_password.dart';
import 'package:my_the_best_project/features/auth/pages/verify_code.dart';
import 'package:my_the_best_project/features/auth/widgets/firebase_stream.dart';
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

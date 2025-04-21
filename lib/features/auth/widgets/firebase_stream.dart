import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/auth/pages/verify_email.dart';
import 'package:my_the_best_project/features/home/pages/navigation_tabbar.dart';

class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // или Splash
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginPage(); // пользователь не залогинен
        }

        if (!user.emailVerified) {
          return const VerifyEmail();
        }

        return const NavigationTabBar(); // всё норм
      },
    );
  }
}

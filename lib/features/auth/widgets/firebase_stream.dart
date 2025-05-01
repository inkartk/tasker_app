import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/features/auth/pages/login_page.dart';
import 'package:my_the_best_project/features/home/pages/navigation_tabbar.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_event.dart';

class FirebaseStream extends StatelessWidget {
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Показываем индикатор, пока ждём авторизацию
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          // Не залогинен
          return const LoginPage();
        }

        // Залогинен: шлём событие на перезагрузку тасков
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<TaskBloc>().add(
                TaskGetEvent(day: DateTime.now()),
              );
        });

        // И возвращаем основной экран
        return const NavigationTabBar();
      },
    );
  }
}
// inkar.tkk@gmail.com
// kairatvnna@gmail.com

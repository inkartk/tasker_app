import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/common/app_router.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/app_database.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_event.dart';

late final AppDatabase database;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  await init(); // ваш DI / BLoC и т.п.
  runApp(
    MultiBlocProvider(
      providers: [
        // старый ToDo-BLoC — для вкладки To Do List
        BlocProvider<TaskBloc>(
          create: (_) => sl<TaskBloc>()..add(TaskGetEvent(day: DateTime.now())),
        ),
        // новый DailyTaskBloc — для календаря и AddTaskPage
        BlocProvider<DailyTaskBloc>(
          create: (_) =>
              sl<DailyTaskBloc>()..add(LoadDailyTaskEvent(day: DateTime.now())),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class GetTaskEvent {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}

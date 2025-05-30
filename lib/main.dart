import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_the_best_project/common/app_router.dart';
import 'package:my_the_best_project/common/di.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_event.dart';
import 'package:my_the_best_project/features/profile/bloc/cubit_profile.dart';
import 'package:my_the_best_project/features/statistic/presentation/bloc/statistics_bloc.dart';
import 'package:my_the_best_project/features/statistic/presentation/bloc/statistics_event.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return MultiBlocProvider(
          providers: [
            if (user != null)
              BlocProvider<DailyTaskBloc>(
                create: (_) => sl<DailyTaskBloc>()
                  ..add(LoadDailyTaskEvent(
                      userID: user.uid, day: DateTime.now())),
              ),
            BlocProvider(create: (_) => sl<ProfileCubit>()),
            BlocProvider(
                create: (_) =>
                    sl<StatisticsBloc>()..add(LoadStatisticsEvent())),
          ],
          child: const MyApp(),
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}

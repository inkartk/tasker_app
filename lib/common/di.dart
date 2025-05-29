import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
// DailyTask feature imports (new)
import 'package:my_the_best_project/features/daily_task/data/local_data_source/daily_app_database.dart';
import 'package:my_the_best_project/features/daily_task/data/local_data_source/daily_task_local_data_source.dart';
import 'package:my_the_best_project/features/daily_task/data/repository/daily_task_repository_impl.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/add_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/delete_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/edit_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/get_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
import 'package:my_the_best_project/features/dashboard/bloc/detail_priority_bloc.dart';
import 'package:my_the_best_project/features/profile/bloc/cubit_profile.dart';
import 'package:my_the_best_project/features/profile/data/profile_repo_impl.dart';
import 'package:my_the_best_project/features/profile/data/profile_repository.dart';
import 'package:my_the_best_project/features/statistic/data/datasource/statistics_local_data_source.dart';
import 'package:my_the_best_project/features/statistic/data/repository/statistics_repository_impl.dart';
import 'package:my_the_best_project/features/statistic/domain/repository/statistic_repository.dart';
import 'package:my_the_best_project/features/statistic/domain/usecases/get_task_statistics.dart';
import 'package:my_the_best_project/features/statistic/presentation/bloc/statistics_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<DailyAppDatabase>(() => DailyAppDatabase());
  sl.registerLazySingleton<DailyTaskLocalDataSource>(
    () => DailyTaskLocalDataSourceImpl(db: sl()),
  );

  // Repository
  sl.registerLazySingleton<DailyTaskRepository>(
    () => DailyTaskRepositoryImpl(localDs: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDailyTask(dailyTaskRepository: sl()));
  sl.registerLazySingleton(() => AddDailyTask(dailyTaskRepository: sl()));
  sl.registerLazySingleton(() => DeleteDailyTask(dailyTaskRepository: sl()));
  sl.registerLazySingleton(() => EditDailyTask(dailyTaskRepository: sl()));

  // Bloc
  sl.registerFactory(() => DailyTaskBloc(
        addDailyTask: sl(),
        deleteDailyTask: sl(),
        editDailyTask: sl(),
        getDailyTask: sl(),
      ));

  sl.registerFactoryParam<DetailPriorityTaskCubit, DailyTask, void>(
    (initialTask, _) => DetailPriorityTaskCubit(
      initialTask: initialTask,
      repository: sl<DailyTaskRepository>(),
    ),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => FirebaseProfileRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      storage: FirebaseStorage.instance,
    ),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(sl<ProfileRepository>()),
  );

  // локальный источник для статистики
  sl.registerLazySingleton<StatisticsLocalDataSource>(
    () => StatisticsLocalDataSourceImpl(sl()),
  );

  // репозиторий статистики: передаём userId из текущего пользователя
  sl.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(
      localDataSource: sl(),
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
  );

  // юзкейс получения статистики
  sl.registerLazySingleton(() => GetTaskStatistics(sl()));

  // BLoC для статистики
  sl.registerFactory(() => StatisticsBloc(sl()));
}

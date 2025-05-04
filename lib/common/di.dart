import 'package:get_it/get_it.dart';
// DailyTask feature imports (new)
import 'package:my_the_best_project/features/daily_task/data/local_data_source/daily_app_database.dart';
import 'package:my_the_best_project/features/daily_task/data/local_data_source/daily_task_local_data_source.dart';
import 'package:my_the_best_project/features/daily_task/data/repository/daily_task_repository_impl.dart';
import 'package:my_the_best_project/features/daily_task/domain/repository/daily_task_repository.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/add_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/delete_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/edit_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/domain/usecases/get_daily_task.dart';
import 'package:my_the_best_project/features/daily_task/presentation/bloc/daily_task_bloc.dart';
// ToDo feature imports (existing)
import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/app_database.dart';
import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/local_datasource.dart';
import 'package:my_the_best_project/features/todo/data/repository/repository_impl.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/add_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/delete_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/get_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/update_task.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ----------------------------
  // ToDo feature registrations
  // ----------------------------

  // Data sources
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(database: sl()),
  );

  // Repository
  sl.registerLazySingleton<Repository>(
    () => RepositoryImpl(localDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTask(repository: sl()));
  sl.registerLazySingleton(() => AddTask(repository: sl()));
  sl.registerLazySingleton(() => DeleteTask(repository: sl()));
  sl.registerLazySingleton(() => UpdateTask(repository: sl()));

  // Bloc
  sl.registerFactory(() => TaskBloc(
        sl(),
        sl(),
        sl(),
        sl(),
      ));

  // ----------------------------
  // DailyTask feature registrations
  // ----------------------------

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
}

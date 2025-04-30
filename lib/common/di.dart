import 'package:get_it/get_it.dart';
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
  // External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(database: sl()), // sl() = AppDatabase
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
  sl.registerFactory(() => TaskBloc(sl(), sl(), sl(), sl()));
}

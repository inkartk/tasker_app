import 'package:get_it/get_it.dart';
import 'package:my_the_best_project/features/todo/data/data_source/local_data_source/local_datasource.dart';
import 'package:my_the_best_project/features/todo/data/repository/repository_impl.dart';
import 'package:my_the_best_project/features/todo/domain/repository/repository.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/add_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/delete_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/get_task.dart';
import 'package:my_the_best_project/features/todo/domain/usecases/update_task.dart';
import 'package:my_the_best_project/features/todo/presentation/bloc/task_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data sources
  sl.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(sharedPreferences: sl()),
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

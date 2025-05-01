import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('TaskEntity')
class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get date => dateTime()();
  TextColumn get userId => text()();
}

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<TaskEntity>> getAllTasks() => select(tasks).get();
  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future updateTask(TaskEntity task) => update(tasks).replace(task);
  Future deleteTask(TaskEntity task) => delete(tasks).delete(task);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));

    if (file.existsSync()) {
      await file.delete();
    }

    return NativeDatabase(file);
  });
}

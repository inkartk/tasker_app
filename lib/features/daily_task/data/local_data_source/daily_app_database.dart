import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:my_the_best_project/features/daily_task/domain/entity/subtasks.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'daily_app_database.g.dart';

@DataClassName('DailyTaskEntity')
class DailyTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text().withLength(min: 1, max: 255)();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get description => text().withLength(min: 0, max: 1000)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  TextColumn get category => text().withLength(min: 1, max: 255)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  TextColumn get subTasksJson => text().map(const SubTaskListConverter())();
}

class SubTaskListConverter extends TypeConverter<List<SubTask>, String> {
  const SubTaskListConverter();

  @override
  List<SubTask> fromSql(String fromDb) {
    final List<dynamic> decoded = jsonDecode(fromDb) as List<dynamic>;
    return decoded
        .map((e) => SubTask.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  String toSql(List<SubTask> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}

@DriftDatabase(tables: [DailyTasks])
class DailyAppDatabase extends _$DailyAppDatabase {
  DailyAppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(dailyTasks, dailyTasks.subTasksJson);
          }
        },
      );

  Future<List<DailyTaskEntity>> getTasksForDayForUser(
    String userId,
    DateTime day,
  ) {
    final startOfDay = DateTime(day.year, day.month, day.day);
    final startOfNext = startOfDay.add(const Duration(days: 1));

    return (select(dailyTasks)
          ..where((t) =>
              t.userId.equals(userId) &
              t.startTime.isSmallerThanValue(startOfNext) &
              t.endTime.isBiggerOrEqualValue(startOfDay)))
        .get();
  }

  Future<int> addDailyTask(DailyTasksCompanion e) => into(dailyTasks).insert(e);

  Future<bool> updateDailyTask(DailyTaskEntity e) =>
      update(dailyTasks).replace(e);

  Future<int> deleteDailyTask(int id) =>
      (delete(dailyTasks)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final d = await getApplicationDocumentsDirectory();
    final f = File(p.join(d.path, 'daily_app.db'));
    return NativeDatabase(f);
  });
}

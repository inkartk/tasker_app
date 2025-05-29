// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_app_database.dart';

// ignore_for_file: type=lint
class $DailyTasksTable extends DailyTasks
    with TableInfo<$DailyTasksTable, DailyTaskEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyTasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 0, maxTextLength: 1000),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _startTimeMeta =
      const VerificationMeta('startTime');
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
      'start_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endTimeMeta =
      const VerificationMeta('endTime');
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
      'end_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _subTasksJsonMeta =
      const VerificationMeta('subTasksJson');
  @override
  late final GeneratedColumnWithTypeConverter<List<SubTask>, String>
      subTasksJson = GeneratedColumn<String>(
              'sub_tasks_json', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<SubTask>>(
              $DailyTasksTable.$convertersubTasksJson);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        description,
        startTime,
        endTime,
        category,
        isDone,
        subTasksJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_tasks';
  @override
  VerificationContext validateIntegrity(Insertable<DailyTaskEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(_startTimeMeta,
          startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta));
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(_endTimeMeta,
          endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta));
    } else if (isInserting) {
      context.missing(_endTimeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    context.handle(_subTasksJsonMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyTaskEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyTaskEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      startTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_time'])!,
      endTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_time'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
      subTasksJson: $DailyTasksTable.$convertersubTasksJson.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}sub_tasks_json'])!),
    );
  }

  @override
  $DailyTasksTable createAlias(String alias) {
    return $DailyTasksTable(attachedDatabase, alias);
  }

  static TypeConverter<List<SubTask>, String> $convertersubTasksJson =
      const SubTaskListConverter();
}

class DailyTaskEntity extends DataClass implements Insertable<DailyTaskEntity> {
  final int id;
  final String userId;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final bool isDone;
  final List<SubTask> subTasksJson;
  const DailyTaskEntity(
      {required this.id,
      required this.userId,
      required this.title,
      required this.description,
      required this.startTime,
      required this.endTime,
      required this.category,
      required this.isDone,
      required this.subTasksJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['start_time'] = Variable<DateTime>(startTime);
    map['end_time'] = Variable<DateTime>(endTime);
    map['category'] = Variable<String>(category);
    map['is_done'] = Variable<bool>(isDone);
    {
      map['sub_tasks_json'] = Variable<String>(
          $DailyTasksTable.$convertersubTasksJson.toSql(subTasksJson));
    }
    return map;
  }

  DailyTasksCompanion toCompanion(bool nullToAbsent) {
    return DailyTasksCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      description: Value(description),
      startTime: Value(startTime),
      endTime: Value(endTime),
      category: Value(category),
      isDone: Value(isDone),
      subTasksJson: Value(subTasksJson),
    );
  }

  factory DailyTaskEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyTaskEntity(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime>(json['endTime']),
      category: serializer.fromJson<String>(json['category']),
      isDone: serializer.fromJson<bool>(json['isDone']),
      subTasksJson: serializer.fromJson<List<SubTask>>(json['subTasksJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime>(endTime),
      'category': serializer.toJson<String>(category),
      'isDone': serializer.toJson<bool>(isDone),
      'subTasksJson': serializer.toJson<List<SubTask>>(subTasksJson),
    };
  }

  DailyTaskEntity copyWith(
          {int? id,
          String? userId,
          String? title,
          String? description,
          DateTime? startTime,
          DateTime? endTime,
          String? category,
          bool? isDone,
          List<SubTask>? subTasksJson}) =>
      DailyTaskEntity(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        category: category ?? this.category,
        isDone: isDone ?? this.isDone,
        subTasksJson: subTasksJson ?? this.subTasksJson,
      );
  DailyTaskEntity copyWithCompanion(DailyTasksCompanion data) {
    return DailyTaskEntity(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      category: data.category.present ? data.category.value : this.category,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
      subTasksJson: data.subTasksJson.present
          ? data.subTasksJson.value
          : this.subTasksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyTaskEntity(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('isDone: $isDone, ')
          ..write('subTasksJson: $subTasksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, title, description, startTime,
      endTime, category, isDone, subTasksJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyTaskEntity &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.category == this.category &&
          other.isDone == this.isDone &&
          other.subTasksJson == this.subTasksJson);
}

class DailyTasksCompanion extends UpdateCompanion<DailyTaskEntity> {
  final Value<int> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> description;
  final Value<DateTime> startTime;
  final Value<DateTime> endTime;
  final Value<String> category;
  final Value<bool> isDone;
  final Value<List<SubTask>> subTasksJson;
  const DailyTasksCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.category = const Value.absent(),
    this.isDone = const Value.absent(),
    this.subTasksJson = const Value.absent(),
  });
  DailyTasksCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String category,
    this.isDone = const Value.absent(),
    required List<SubTask> subTasksJson,
  })  : userId = Value(userId),
        title = Value(title),
        description = Value(description),
        startTime = Value(startTime),
        endTime = Value(endTime),
        category = Value(category),
        subTasksJson = Value(subTasksJson);
  static Insertable<DailyTaskEntity> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<String>? category,
    Expression<bool>? isDone,
    Expression<String>? subTasksJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (category != null) 'category': category,
      if (isDone != null) 'is_done': isDone,
      if (subTasksJson != null) 'sub_tasks_json': subTasksJson,
    });
  }

  DailyTasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? userId,
      Value<String>? title,
      Value<String>? description,
      Value<DateTime>? startTime,
      Value<DateTime>? endTime,
      Value<String>? category,
      Value<bool>? isDone,
      Value<List<SubTask>>? subTasksJson}) {
    return DailyTasksCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
      subTasksJson: subTasksJson ?? this.subTasksJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (subTasksJson.present) {
      map['sub_tasks_json'] = Variable<String>(
          $DailyTasksTable.$convertersubTasksJson.toSql(subTasksJson.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyTasksCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('category: $category, ')
          ..write('isDone: $isDone, ')
          ..write('subTasksJson: $subTasksJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$DailyAppDatabase extends GeneratedDatabase {
  _$DailyAppDatabase(QueryExecutor e) : super(e);
  $DailyAppDatabaseManager get managers => $DailyAppDatabaseManager(this);
  late final $DailyTasksTable dailyTasks = $DailyTasksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [dailyTasks];
}

typedef $$DailyTasksTableCreateCompanionBuilder = DailyTasksCompanion Function({
  Value<int> id,
  required String userId,
  required String title,
  required String description,
  required DateTime startTime,
  required DateTime endTime,
  required String category,
  Value<bool> isDone,
  required List<SubTask> subTasksJson,
});
typedef $$DailyTasksTableUpdateCompanionBuilder = DailyTasksCompanion Function({
  Value<int> id,
  Value<String> userId,
  Value<String> title,
  Value<String> description,
  Value<DateTime> startTime,
  Value<DateTime> endTime,
  Value<String> category,
  Value<bool> isDone,
  Value<List<SubTask>> subTasksJson,
});

class $$DailyTasksTableFilterComposer
    extends Composer<_$DailyAppDatabase, $DailyTasksTable> {
  $$DailyTasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<SubTask>, List<SubTask>, String>
      get subTasksJson => $composableBuilder(
          column: $table.subTasksJson,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$DailyTasksTableOrderingComposer
    extends Composer<_$DailyAppDatabase, $DailyTasksTable> {
  $$DailyTasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
      column: $table.startTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
      column: $table.endTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subTasksJson => $composableBuilder(
      column: $table.subTasksJson,
      builder: (column) => ColumnOrderings(column));
}

class $$DailyTasksTableAnnotationComposer
    extends Composer<_$DailyAppDatabase, $DailyTasksTable> {
  $$DailyTasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<SubTask>, String> get subTasksJson =>
      $composableBuilder(
          column: $table.subTasksJson, builder: (column) => column);
}

class $$DailyTasksTableTableManager extends RootTableManager<
    _$DailyAppDatabase,
    $DailyTasksTable,
    DailyTaskEntity,
    $$DailyTasksTableFilterComposer,
    $$DailyTasksTableOrderingComposer,
    $$DailyTasksTableAnnotationComposer,
    $$DailyTasksTableCreateCompanionBuilder,
    $$DailyTasksTableUpdateCompanionBuilder,
    (
      DailyTaskEntity,
      BaseReferences<_$DailyAppDatabase, $DailyTasksTable, DailyTaskEntity>
    ),
    DailyTaskEntity,
    PrefetchHooks Function()> {
  $$DailyTasksTableTableManager(_$DailyAppDatabase db, $DailyTasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyTasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyTasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyTasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<DateTime> startTime = const Value.absent(),
            Value<DateTime> endTime = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<List<SubTask>> subTasksJson = const Value.absent(),
          }) =>
              DailyTasksCompanion(
            id: id,
            userId: userId,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            category: category,
            isDone: isDone,
            subTasksJson: subTasksJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String userId,
            required String title,
            required String description,
            required DateTime startTime,
            required DateTime endTime,
            required String category,
            Value<bool> isDone = const Value.absent(),
            required List<SubTask> subTasksJson,
          }) =>
              DailyTasksCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            description: description,
            startTime: startTime,
            endTime: endTime,
            category: category,
            isDone: isDone,
            subTasksJson: subTasksJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailyTasksTableProcessedTableManager = ProcessedTableManager<
    _$DailyAppDatabase,
    $DailyTasksTable,
    DailyTaskEntity,
    $$DailyTasksTableFilterComposer,
    $$DailyTasksTableOrderingComposer,
    $$DailyTasksTableAnnotationComposer,
    $$DailyTasksTableCreateCompanionBuilder,
    $$DailyTasksTableUpdateCompanionBuilder,
    (
      DailyTaskEntity,
      BaseReferences<_$DailyAppDatabase, $DailyTasksTable, DailyTaskEntity>
    ),
    DailyTaskEntity,
    PrefetchHooks Function()>;

class $DailyAppDatabaseManager {
  final _$DailyAppDatabase _db;
  $DailyAppDatabaseManager(this._db);
  $$DailyTasksTableTableManager get dailyTasks =>
      $$DailyTasksTableTableManager(_db, _db.dailyTasks);
}

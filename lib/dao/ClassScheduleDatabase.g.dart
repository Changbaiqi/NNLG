// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ClassScheduleDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ClassScheduleDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ClassScheduleDatabaseBuilderContract addMigrations(
      List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ClassScheduleDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ClassScheduleDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorClassScheduleDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ClassScheduleDatabaseBuilderContract databaseBuilder(String name) =>
      _$ClassScheduleDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ClassScheduleDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ClassScheduleDatabaseBuilder(null);
}

class _$ClassScheduleDatabaseBuilder
    implements $ClassScheduleDatabaseBuilderContract {
  _$ClassScheduleDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ClassScheduleDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ClassScheduleDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ClassScheduleDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ClassScheduleDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ClassScheduleDatabase extends ClassScheduleDatabase {
  _$ClassScheduleDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ClassScheduleDao? _classScheduleDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 5,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ClassScheduleEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `studentId` TEXT, `semester` TEXT, `uid` TEXT, `dateTime` INTEGER, `md5` TEXT, `list` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ClassScheduleDao get classScheduleDao {
    return _classScheduleDaoInstance ??=
        _$ClassScheduleDao(database, changeListener);
  }
}

class _$ClassScheduleDao extends ClassScheduleDao {
  _$ClassScheduleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _classScheduleEntityInsertionAdapter = InsertionAdapter(
            database,
            'ClassScheduleEntity',
            (ClassScheduleEntity item) => <String, Object?>{
                  'id': item.id,
                  'studentId': item.studentId,
                  'semester': item.semester,
                  'uid': item.uid,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'md5': item.md5,
                  'list': _stringListConverter.encode(item.list)
                }),
        _classScheduleEntityDeletionAdapter = DeletionAdapter(
            database,
            'ClassScheduleEntity',
            ['id'],
            (ClassScheduleEntity item) => <String, Object?>{
                  'id': item.id,
                  'studentId': item.studentId,
                  'semester': item.semester,
                  'uid': item.uid,
                  'dateTime': _dateTimeConverter.encode(item.dateTime),
                  'md5': item.md5,
                  'list': _stringListConverter.encode(item.list)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ClassScheduleEntity>
      _classScheduleEntityInsertionAdapter;

  final DeletionAdapter<ClassScheduleEntity>
      _classScheduleEntityDeletionAdapter;

  @override
  Future<List<ClassScheduleEntity>> findAllClassSchedule() async {
    return _queryAdapter.queryList('SELECT * FROM ClassScheduleEntity',
        mapper: (Map<String, Object?> row) => ClassScheduleEntity(
            id: row['id'] as int?,
            studentId: row['studentId'] as String?,
            semester: row['semester'] as String?,
            uid: row['uid'] as String?,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int?),
            md5: row['md5'] as String?,
            list: _stringListConverter.decode(row['list'] as String)));
  }

  @override
  Future<List<ClassScheduleEntity>> findAllClassScheduleForStudentIdAndSemester(
    String studentId,
    String semester,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ClassScheduleEntity WHERE studentId= ?1 and semester= ?2',
        mapper: (Map<String, Object?> row) => ClassScheduleEntity(id: row['id'] as int?, studentId: row['studentId'] as String?, semester: row['semester'] as String?, uid: row['uid'] as String?, dateTime: _dateTimeConverter.decode(row['dateTime'] as int?), md5: row['md5'] as String?, list: _stringListConverter.decode(row['list'] as String)),
        arguments: [studentId, semester]);
  }

  @override
  Future<ClassScheduleEntity?> findClassScheduleForUid(String uid) async {
    return _queryAdapter.query(
        'SELECT * FROM ClassScheduleEntity WHERE uid= ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => ClassScheduleEntity(
            id: row['id'] as int?,
            studentId: row['studentId'] as String?,
            semester: row['semester'] as String?,
            uid: row['uid'] as String?,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int?),
            md5: row['md5'] as String?,
            list: _stringListConverter.decode(row['list'] as String)),
        arguments: [uid]);
  }

  @override
  Future<ClassScheduleEntity?> findNewestClassSchedule(
    String studentId,
    String semester,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM ClassScheduleEntity WHERE studentId= ?1 AND semester= ?2 ORDER BY dateTime DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => ClassScheduleEntity(id: row['id'] as int?, studentId: row['studentId'] as String?, semester: row['semester'] as String?, uid: row['uid'] as String?, dateTime: _dateTimeConverter.decode(row['dateTime'] as int?), md5: row['md5'] as String?, list: _stringListConverter.decode(row['list'] as String)),
        arguments: [studentId, semester]);
  }

  @override
  Future<List<ClassScheduleEntity>> findClassScheduleListForUid(
      String uid) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ClassScheduleEntity WHERE uid= ?1',
        mapper: (Map<String, Object?> row) => ClassScheduleEntity(
            id: row['id'] as int?,
            studentId: row['studentId'] as String?,
            semester: row['semester'] as String?,
            uid: row['uid'] as String?,
            dateTime: _dateTimeConverter.decode(row['dateTime'] as int?),
            md5: row['md5'] as String?,
            list: _stringListConverter.decode(row['list'] as String)),
        arguments: [uid]);
  }

  @override
  Future<void> insertClassSchedule(
      ClassScheduleEntity classScheduleEntity) async {
    await _classScheduleEntityInsertionAdapter.insert(
        classScheduleEntity, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteClassSchedule(ClassScheduleEntity classScheduleEntity) {
    return _classScheduleEntityDeletionAdapter
        .deleteAndReturnChangedRows(classScheduleEntity);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _stringListConverter = StringListConverter();

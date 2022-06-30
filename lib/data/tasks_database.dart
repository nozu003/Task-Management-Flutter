// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// import '../models/task.dart';

// class TasksDatabase {
//   static final TasksDatabase instance = TasksDatabase._init();

//   static Database? _database;

//   TasksDatabase._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('tasks.db');
//     return _database!;
//   }

//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);

//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }

//   Future _createDB(Database db, int version) async {
//     final id = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     final textTypeNotNull = 'TEXT NOT NULL';
//     final textTypeNull = 'TEXT NULL';
//     final integerTypeNotNull = 'INTEGER NOT NULL';

//     await db.execute('''
//     CREATE TABLE $tableTasks(
//       ${TaskFields.taskId} $id,
//       ${TaskFields.taskName} $textTypeNotNull,
//       ${TaskFields.taskDescription} $textTypeNotNull,
//       ${TaskFields.dateCreated} $textTypeNotNull,
//       ${TaskFields.dateModified} $textTypeNotNull,
//       ${TaskFields.dateCompleted} $textTypeNull,
//       ${TaskFields.status} $integerTypeNotNull)
//     ''');

//     await db.execute(''' 
//     CREATE TABLE $tableTags(
//       ${TagFields.tagId} $textTypeNull,
//       ${TagFields.tagName} $textTypeNull,
//       ${TagFields.taskId} $textTypeNull,
//       FOREIGN KEY (${TagFields.taskId}) REFERENCES $tableTasks (${TaskFields.taskId})
//     )
//     ''');
//   }

//   Future<Task> create(Task task) async {
//     final db = await instance.database;

//     final json = task.toJson();

//     final columns =
//         '${TaskFields.taskName}, ${TaskFields.taskDescription}, ${TaskFields.dateCreated}, ${TaskFields.dateModified}, ${TaskFields.status}';

//     final values =
//         ''' '${json[TaskFields.taskName]}', '${json[TaskFields.taskDescription]}', '${json[TaskFields.dateCreated]}', '${json[TaskFields.dateModified]}', ${json[TaskFields.status]} ''';

//     final sql = 'INSERT INTO tasks ($columns) VALUES ($values)';

//     final taskId = await db.rawInsert(sql);
//     return task.copy(taskId: taskId);
//   }

//   Future<Task> getTaskById(int taskId) async {
//     final db = await instance.database;

//     final maps = await db.query(tableTasks,
//         columns: TaskFields.values,
//         where: '${TaskFields.taskId} = ?',
//         whereArgs: [taskId]);

//     if (maps.isNotEmpty) {
//       return Task.fromJson(maps.first);
//     } else {
//       throw Exception('Task with $taskId not found');
//     }
//   }

//   Future<List<Task>> getTasks() async {
//     //implement checker
//     final db = await instance.database;
//     final result = await db.query(tableTasks);
//     return result.map((json) => Task.fromJson(json)).toList();
//   }

//   Future<int> updateTask(Task task) async {
//     final db = await instance.database;

//     return db.update(tableTasks, task.toJson(),
//         where: '${TaskFields.taskId} = ?', whereArgs: [task.taskId]);
//   }

//   Future<int> deleteTask(int taskId) async {
//     final db = await instance.database;

//     return await db.delete(tableTasks,
//         where: '${TaskFields.taskId} = ?', whereArgs: [taskId]);
//   }

//   Future close() async {
//     final db = await instance.database;
//     db.close();
//   }
// }

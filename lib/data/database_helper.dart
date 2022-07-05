import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task_management_v2/data/tables/tag_table.dart';
import 'package:task_management_v2/data/tables/task_table.dart';

import '../models/task.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> getInstance() async {
    _database ??= await _initDB('TaskManagement.sqlite');
    return _database!;
  }

  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static Future _createDB(Database db, int version) async {
    await db.execute(TaskTable.query);
    await db.execute(TagTable.query);
  }

  Future close() async {
    final db = await getInstance();
    db.close();
  }
}

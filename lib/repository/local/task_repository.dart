import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:task_management_v2/data/database_helper.dart';

import '../../data/tables/tag_table.dart';
import '../../data/tables/task_table.dart';
import '../../models/task.dart';

class TaskRepositoryLocal {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<ITask>> getTasks() async {
    //implement checker
    final db = await DatabaseHelper.getInstance();
    final result = await db.query(TaskTable.tableName);
    return result.map((json) => ITask.fromJson(json)).toList();
  }

  Future<ITask> getTaskById(String taskId) async {
    final db = await DatabaseHelper.getInstance();

    final maps = await db.query(TaskTable.tableName,
        where: '${TaskTable.taskId} = ?', whereArgs: [taskId]);
    if (maps.isNotEmpty) {
      return ITask.fromJson(maps.first);
    } else {
      throw Exception('ITask with $taskId not found');
    }
  }

  Future postTask(ITask task) async {
    final db = await DatabaseHelper.getInstance();
    Batch batch = db.batch();
    batch.insert(
      TaskTable.tableName,
      task.toMap(false),
    );
    if (task.tags != null) {
      for (var tag in task.tags!) {
        tag.taskId = task.taskId;
        batch.insert(TagTable.tableName, tag.toMap(false));
      }
    }
    await batch.commit(noResult: true);
  }

  Future updateTask(ITask task) async {
    final db = await DatabaseHelper.getInstance();
    Batch batch = db.batch();

    batch.update(TaskTable.tableName, task.toMap(true),
        where: '${TaskTable.taskId} = ?', whereArgs: [task.taskId]);
    if (task.tags != null || task.tags != []) {
      for (var tag in task.tags!) {
        batch.update(TagTable.tableName, tag.toMap(true),
            where: '${TagTable.tagId} = ?', whereArgs: [tag.tagId]);
      }
    }
    await batch.commit(noResult: true);
  }

  Future deleteTask(String taskId) async {
    final db = await DatabaseHelper.getInstance();
    await db.delete(TaskTable.tableName,
        where: '${TaskTable.taskId} = ?', whereArgs: [taskId]);
  }
}

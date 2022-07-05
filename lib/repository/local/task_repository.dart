import 'package:sqflite/sqflite.dart';
import 'package:task_management_v2/data/database_helper.dart';

import '../../data/tables/tag_table.dart';
import '../../data/tables/task_table.dart';
import '../../models/task.dart';

class TaskRepositoryLocal {
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
      task.toMap(),
    );
    if (task.tags != null) {
      for (var tag in task.tags!) {
        batch.insert(TagTable.tableName, tag.toMap());
      }
    }
    await batch.commit(noResult: true);
  }

  Future updateTask(ITask task) async {
    final db = await DatabaseHelper.getInstance();
    Batch batch = db.batch();

    batch.update(TaskTable.tableName, task.toJson(),
        where: '${TaskTable.taskId} = ?', whereArgs: [task.taskId]);
    if (task.tags != null) {
      for (var tag in task.tags!) {
        batch.update(TagTable.tableName, tag.toMap());
      }
    }
    await batch.commit(noResult: true);
  }

  Future<int> deleteTask(String taskId) async {
    final db = await DatabaseHelper.getInstance();
    return await db.delete(TaskTable.tableName,
        where: '${TaskTable.taskId} = ?', whereArgs: [taskId]);
  }
}

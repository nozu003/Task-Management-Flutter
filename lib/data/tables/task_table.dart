class TaskTable {
  static const String tableName = 'tasks';
  static const String taskId = 'taskId';
  static const String taskName = 'taskName';
  static const String taskDescription = 'taskDescription';
  static const String dateCreated = 'dateCreated';
  static const String dateModified = 'dateModified';
  static const String dateCompleted = 'dateCompleted';
  static const String status = 'status';

  static const String query = ''' 
  CREATE TABLE IF NOT EXISTS $tableName(
      $taskId TEXT NOT NULL,
      $taskName TEXT NOT NULL,
      $taskDescription TEXT NOT NULL,
      $dateCreated TEXT NOT NULL,
      $dateModified TEXT NOT NULL,
      $dateCompleted TEXT,
      $status INTEGER NOT NULL,
      PRIMARY KEY ($taskId)
      )
  ''';
}

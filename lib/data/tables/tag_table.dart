class TagTable {
  static const String tableName = 'tags';
  static const String tagId = 'tagId';
  static const String tagName = 'tagName';
  static const String taskId = 'taskId';

  static const String query = ''' 
  CREATE TABLE IF NOT EXISTS $tableName(
      $tagId TEXT NOT NULL,
      $tagName TEXT NOT NULL,
      $taskId TEXT NOT NULL,
      PRIMARY KEY ($tagId),
      CONSTRAINT FK_taskId FOREIGN KEY(taskId) REFERENCES tasks(taskId) ON DELETE CASCADE
      )
  ''';
}

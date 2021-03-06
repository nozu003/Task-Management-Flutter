import 'package:intl/intl.dart';
import 'package:faker/faker.dart';

class ITask {
  String? taskId = '';
  String taskName = '';
  String taskDescription = '';
  String? dateCreated = '';
  String? dateModified = '';
  String? dateCompleted = '';
  TaskStatus status = TaskStatus.New;
  List<ITag>? tags = [];

  ITask(this.taskName, this.taskDescription, this.tags, this.status);

  ITask.fromJson(Map<String, dynamic> taskMap) {
    taskId = taskMap['taskId'];
    taskName = taskMap['taskName'];
    taskDescription = taskMap['taskDescription'];
    dateCreated = taskMap['dateCreated'];
    dateCreated = DateFormat.yMMMMd().format(DateTime.parse(dateCreated!));
    dateModified = taskMap['dateModified'];
    dateModified = DateFormat.yMMMMd().format(DateTime.parse(dateModified!));
    if (taskMap['dateCompleted'] != null) {
      dateCompleted = taskMap['dateCompleted'];
      dateCompleted =
          DateFormat.yMMMMd().format(DateTime.parse(dateCompleted!));
    }
    switch (taskMap['status']) {
      case 0:
        status = TaskStatus.New;
        break;
      case 1:
        status = TaskStatus.InProgress;
        break;
      case 2:
        status = TaskStatus.Completed;
        break;
      default:
        break;
    }
    for (Map<String, dynamic> tag in taskMap['tags']) {
      tags!.add(ITag.fromJson(tag));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['tags'] = tags;
    switch (status) {
      case TaskStatus.New:
        data['status'] = 0;
        break;
      case TaskStatus.InProgress:
        data['status'] = 1;
        break;
      case TaskStatus.Completed:
        data['status'] = 2;
        break;
      default:
        break;
    }

    return data;
  }
}

class ITag {
  String? tagId = '';
  String tagName = '';
  String? taskId = '';

  ITag(this.tagName);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['tagId'] = tagId;
    data['tagName'] = tagName;
    // data['taskId'] = taskId;
    return data;
  }

  ITag.fromJson(Map<String, dynamic> taskMap) {
    tagId = taskMap['tagId'];
    tagName = taskMap['tagName'];
    taskId = taskMap['taskId'];
  }
}

enum TaskStatus { New, InProgress, Completed }

//Database
final String tableTasks = 'tasks';
final String tableTags = 'tags';

class Task {
  // String? taskId = faker.guid.guid();
  int? taskId;
  String taskName;
  String taskDescription;
  DateTime dateCreated = DateTime.now();
  DateTime dateModified = DateTime.now();
  DateTime? dateCompleted;
  int status = 0;

  Task(
      {this.taskId,
      required this.taskName,
      required this.taskDescription,
      required this.dateCreated,
      required this.dateModified,
      this.dateCompleted,
      required this.status});

  Task copy({
    int? taskId,
    String? taskName,
    String? taskDescription,
    DateTime? dateCreated,
    DateTime? dateModified,
    DateTime? dateCompleted,
    int? status,
  }) =>
      Task(
          taskId: taskId ?? this.taskId,
          taskName: taskName ?? this.taskName,
          taskDescription: taskDescription ?? this.taskDescription,
          dateCreated: dateCreated ?? this.dateCreated,
          dateModified: dateModified ?? this.dateModified,
          dateCompleted: dateCompleted ?? this.dateCompleted,
          status: status ?? this.status);

  static Task fromJson(Map<String, Object?> json) => Task(
      taskId: json[TaskFields.taskId] as int?,
      taskName: json[TaskFields.taskName] as String,
      taskDescription: json[TaskFields.taskDescription] as String,
      dateCreated: DateTime.parse(json[TaskFields.dateCreated] as String),
      dateModified: DateTime.parse(json[TaskFields.dateModified] as String),
      status: json[TaskFields.status] as int);

  Map<String, Object?> toJson() => {
        TaskFields.taskId: taskId,
        TaskFields.taskName: taskName,
        TaskFields.taskDescription: taskDescription,
        TaskFields.dateCreated: dateCreated.toIso8601String(),
        TaskFields.dateModified: dateModified.toIso8601String(),
        // TaskFields.dateCompleted: dateCompleted!.toIso8601String(),
        TaskFields.status: status
      };
}

class TaskFields {
  static final List<String> values = [
    taskId,
    taskName,
    taskDescription,
    dateCreated,
    dateModified,
    dateCompleted,
    status
  ];

  // static final String taskId = faker.guid.guid();
  static final String taskId = '_taskId';
  static final String taskName = 'taskName';
  static final String taskDescription = 'taskDescription';
  static final String dateCreated = 'dateCreated';
  static final String dateModified = 'dateModified';
  static final String dateCompleted = 'dateCompleted';
  static final String status = 'status';
}

class TagFields {
  // static final String tagId = faker.guid.guid();
  static final String tagId = '_tagId';
  static final String tagName = 'tagName';
  static final String taskId = TaskFields.taskId;
}

import 'package:intl/intl.dart';

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

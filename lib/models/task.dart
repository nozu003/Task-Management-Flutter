import 'package:intl/intl.dart';
import 'package:faker/faker.dart';

class ITask {
  late String? taskId = '';
  late String taskName = '';
  late String taskDescription = '';
  late String? dateCreated = '';
  late String? dateModified = '';
  late String? dateCompleted = '';
  late TaskStatus status = TaskStatus.New;
  late List<ITag>? tags = [];

  ITask(
      {this.taskId,
      required this.taskName,
      required this.taskDescription,
      this.dateCreated,
      this.dateModified,
      this.dateCompleted,
      this.tags,
      required this.status});

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
    if (taskId != null) {
      data['taskId'] = taskId;
    }
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
    if (dateCreated != null) {
      data['dateCreated'] = dateCreated;
    }
    if (dateModified != null) {
      data['dateModified'] = dateModified;
    }
    if (dateCompleted != null) {
      data['dateCompleted'] = dateCompleted;
    }
    return data;
  }

  Map<String, dynamic> toMap(bool isUpdate) {
    int convertedStatus = 0;

    switch (status) {
      case TaskStatus.New:
        convertedStatus = 0;
        break;
      case TaskStatus.InProgress:
        convertedStatus = 1;
        break;
      case TaskStatus.Completed:
        convertedStatus = 2;
        break;
      default:
        break;
    }
    return {
      'taskId': taskId,
      'taskName': taskName,
      'taskDescription': taskDescription,
      'dateCreated': dateCreated,
      'dateModified': dateModified,
      'dateCompleted': dateCompleted,
      'status': convertedStatus
    };
  }
}

class ITag {
  String? tagId = '';
  String tagName = '';
  String? taskId = '';

  ITag({required this.tagName});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tagId!.isNotEmpty) {
      data['tagId'] = tagId;
    }
    data['tagName'] = tagName;
    if (taskId!.isNotEmpty) {
      data['taskId'] = taskId;
    }
    return data;
  }

  ITag.fromJson(Map<String, dynamic> taskMap) {
    tagId = taskMap['tagId'];
    tagName = taskMap['tagName'];
    taskId = taskMap['taskId'];
  }

  Map<String, dynamic> toMap(bool isUpdate) {
    return {'tagId': tagId, 'tagName': tagName, 'taskId': taskId};
  }
}

enum TaskStatus { New, InProgress, Completed }

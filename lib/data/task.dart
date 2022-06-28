import 'package:intl/intl.dart';

class ITask {
  String? taskId = '';
  String taskName = '';
  String taskDescription = '';
  String? dateCreated = '';
  String? status = '';
  List<ITag>? tags = [];

  ITask(this.taskName, this.taskDescription, this.tags);

  ITask.fromJson(Map<String, dynamic> taskMap) {
    taskId = taskMap['taskId'];
    taskName = taskMap['taskName'];
    taskDescription = taskMap['taskDescription'];
    dateCreated = taskMap['dateCreated'];
    dateCreated = DateFormat.yMMMMd().format(DateTime.parse(dateCreated!));
    switch (taskMap['status']) {
      case 0:
        status = 'New';
        break;
      case 1:
        status = 'In Progress';
        break;
      case 2:
        status = 'Completed';
        break;
      default:
        break;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['tags'] = tags;
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
    data['tagName'] = tagName;
    return data;
  }
}

import 'package:intl/intl.dart';

class ITask {
  String taskName = '';
  String taskDescription = '';
  String dateCreated = '';
  String status = '';

  ITask(this.taskName, this.taskDescription, this.status);

  ITask.fromJson(Map<String, dynamic> taskMap) {
    taskName = taskMap['taskName'];
    taskDescription = taskMap['taskDescription'];
    dateCreated = taskMap['dateCreated'];
    dateCreated = DateFormat.yMMMMd().format(DateTime.parse(dateCreated));
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
}

import 'package:task_management_v2/repository/api/task_repository.dart';

import '../models/task.dart';

class TaskServiceAPI {
  final TaskRepositoryAPI _taskRepository = TaskRepositoryAPI();

  getTasks() {
    return _taskRepository.getTasks();
  }

  getTaskById(String taskId) {
    return _taskRepository.getTaskById(taskId);
  }

  postTask(ITask task) {
    return _taskRepository.postTask(task);
  }

  updateTask(String taskId, ITask task) {
    return _taskRepository.updateTask(taskId, task);
  }

  deleteTask(String taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}

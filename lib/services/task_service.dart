import 'package:task_management_v2/repository/api/task_repository.dart';

import '../models/task.dart';

class TaskService {
  final TaskRepository _taskRepository = TaskRepository();

  getTasks() {
    return _taskRepository.getTasks();
  }

  getTaskById(String taskId) {
    return _taskRepository.getTaskById(taskId);
  }

  postTask(ITask task) {
    return _taskRepository.postTask(task);
  }

  updateTask(ITask task) {
    return _taskRepository.updateTask(task.taskId!, task);
  }

  deleteTask(String taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}

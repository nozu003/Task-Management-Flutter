import '../models/task.dart';
import '../repository/local/task_repository.dart';

class TaskServiceLocal {
  final TaskRepositoryLocal _taskRepository = TaskRepositoryLocal();

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
    return _taskRepository.updateTask(task);
  }

  deleteTask(String taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}

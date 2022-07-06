import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:task_management_v2/data/http_config.dart';
import 'dart:convert';

import 'package:task_management_v2/models/task.dart';

class TaskRepositoryAPI {
  final String _authority = HttpConfig().authority;
  final String _unencodedPath = HttpConfig().unencodedPath;
  final Map<String, dynamic> _queryParameters = HttpConfig().queryParameters;

  /** 
   * Retrieves all the tasks in the api
  */
  Future<List<ITask>> getTasks() async {
    List<ITask> tasks = [];
    Uri uri = Uri.https(_authority, _unencodedPath, _queryParameters);
    http.Response result = await http.get(uri);

    final data = json.decode(result.body);
    for (Map<String, dynamic> datum in data) {
      tasks.add(ITask.fromJson(datum));
    }
    if (result.statusCode == 200) {
      return tasks;
    } else {
      throw Exception('Failed to get tasks');
    }
  }

  /** 
   * Retrieves a specific task based on the taskId
  */
  Future<ITask> getTaskById(String taskId) async {
    String encodedPath = '$_unencodedPath/$taskId';
    Uri uri = Uri.https(_authority, encodedPath);
    http.Response result = await http.get(uri);
    final data = json.decode(result.body);
    var task = ITask.fromJson(data);
    return task;
  }

  /** 
   * Creates a new task
  */
  Future<http.Response> postTask(ITask task) async {
    Uri uri = Uri.https(_authority, _unencodedPath);
    http.Response result = await http.post(uri,
        body: jsonEncode(task.toJson()),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return result;
  }

  /** 
   * Updated a specific task based on the taskId
  */
  Future<http.Response> updateTask(String taskId, ITask task) async {
    String encodedPath = '$_unencodedPath/$taskId';
    Uri uri = Uri.https(_authority, encodedPath);
    http.Response result = await http.put(uri,
        body: jsonEncode(task.toJson()),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return result;
  }

  /** 
   * Deletes a specific task based on the taskId
  */
  Future<http.Response> deleteTask(String taskId) async {
    String encodedPath = '$_unencodedPath/$taskId';
    Uri uri = Uri.https(_authority, encodedPath);
    http.Response result = await http.delete(uri);
    return result;
  }
}

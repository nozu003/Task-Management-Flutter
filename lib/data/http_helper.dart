import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task_management_v2/data/task.dart';

class HttpHelper {
  final String authority = '10.0.2.2:7185'; //change 7185 to your swagger url
  final String unencodedPath = 'api/tasks';
  final Map<String, dynamic> queryParameters = {
    'pageSize': '50',
    'pageNumber': '1'
  };

  Future<List<ITask>> getTasks() async {
    List<ITask> tasks = [];
    Uri uri = Uri.https(authority, unencodedPath, queryParameters);
    http.Response result = await http.get(uri);

    final data = json.decode(result.body);
    for (Map<String, dynamic> datum in data) {
      tasks.add(ITask.fromJson(datum));
    }

    return tasks;
  }

  Future<http.Response> postTask(ITask task) async {
    Map<String, dynamic> newTask = {
      'taskName': task.taskName,
      'taskDescription': task.taskDescription,
      'tags': task.tags
    };

    Uri uri = Uri.https(authority, unencodedPath);
    http.Response result = await http.post(uri,
        body: jsonEncode(task.toJson()),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    return result;
  }

  Future<http.Response> deleteTask(String taskId) async {
    String encodedPath = '${this.unencodedPath}/${taskId}';
    Uri uri = Uri.https(authority, encodedPath);
    http.Response result = await http.delete(uri);
    return result;
  }
}

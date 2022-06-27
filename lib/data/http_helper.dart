import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task_management_v2/data/task.dart';

class HttpHelper {
  final String authority = '10.0.2.2:7185'; //change 7185 to your swagger url
  final String unencodedPath = 'api/tasks';

  Future<List<ITask>> getTasks() async {
    List<ITask> tasks = [];
    Uri uri = Uri.https(authority, unencodedPath);
    http.Response result = await http.get(uri);

    final data = json.decode(result.body);
    for (Map<String, dynamic> datum in data) {
      tasks.add(ITask.fromJson(datum));
    }

    return tasks;
  }
}

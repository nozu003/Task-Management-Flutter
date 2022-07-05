import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_management_v2/data/database_helper.dart';
import 'package:task_management_v2/repository/api/task_repository.dart';
import 'package:task_management_v2/services/task_service_api.dart';
import 'package:task_management_v2/services/task_service_local.dart';

import '../models/task.dart';

class ViewTask extends StatefulWidget {
  final String taskId;
  const ViewTask({required this.taskId, Key? key}) : super(key: key);

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  final TaskServiceAPI _taskServiceAPI = TaskServiceAPI();
  final TaskServiceLocal _taskServiceLocal = TaskServiceLocal();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  late List<ITag> tags = [];
  late ITask task = ITask(
      taskName: 'taskName',
      taskDescription: 'taskDescription',
      status: TaskStatus.New);

  Future getTaskById() async {
    var result = await _taskServiceAPI.getTaskById(widget.taskId);
    // var result = await TasksDatabase.instance.getTaskById(widget.taskId);
    task = ITask(
        taskId: result.taskId,
        taskName: result.taskName,
        taskDescription: result.taskDescription,
        dateCreated: result.dateCreated,
        dateModified: result.dateModified,
        dateCompleted: result.dateCompleted!,
        status: result.status);
    _taskNameController.text = task.taskName;
    _taskDescriptionController.text = task.taskDescription;
    setState(() {
      tags.addAll(result.tags!);
    });
  }

  @override
  void initState() {
    super.initState();
    getTaskById();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              onChanged: (value) => {updateTask()},
              controller: _taskNameController,
              decoration: InputDecoration(border: InputBorder.none),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
            TextFormField(
              onChanged: (value) => {updateTask()},
              controller: _taskDescriptionController,
              decoration: InputDecoration(border: InputBorder.none),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (var i = 0; i < tags.length; i++)
                    Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Badge(
                          elevation: 0,
                          shape: BadgeShape.square,
                          toAnimate: false,
                          badgeContent: Text(
                            tags[i].tagName,
                            style: TextStyle(color: Color(0xff7239EA)),
                          ),
                          badgeColor: Color(0xffF8F5FF),
                        ))
                ])),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                    message: 'Created at ${task.dateCreated}',
                    child: task.dateCompleted!.isEmpty
                        ? Text('Edited ${task.dateModified}')
                        : Text('Completed at ${task.dateCompleted}')),
                Spacer(),
                IconButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text('Add tag'),
                                leading: Icon(Icons.label),
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              ListTile(
                                title: Text('Make a copy'),
                                leading: Icon(Icons.content_copy),
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              ListTile(
                                title: Text('Delete task'),
                                leading: Icon(Icons.delete),
                                onTap: () => Navigator.of(context).pop(),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            )
          ],
        ),
      )),
    );
  }

  Future updateTask() async {
    String taskName = _taskNameController.text.trim();
    String taskDescription = _taskDescriptionController.text.trim();

    task = ITask(
        taskId: task.taskId,
        taskName: taskName,
        taskDescription: taskDescription,
        status: task.status);

    http.Response result =
        await _taskServiceAPI.updateTask(widget.taskId, task);
    print(result.statusCode);
    // var result = await TasksDatabase.instance.updateTask(task);
  }
}

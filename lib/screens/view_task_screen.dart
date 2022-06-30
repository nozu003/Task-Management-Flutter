import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:task_management_v2/data/db/tasks_database.dart';
import 'package:task_management_v2/data/http_helper.dart';

import '../data/task.dart';

class ViewTask extends StatefulWidget {
  final int taskId;
  // final String taskId;
  const ViewTask({required this.taskId, Key? key}) : super(key: key);

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  late int _taskId = 0;
  // late String _taskId = '';
  late TextEditingController _taskNameController = TextEditingController();
  late TextEditingController _taskDescriptionController =
      TextEditingController();
  late TextEditingController _dateCreatedController = TextEditingController();
  late TextEditingController _dateModifiedController = TextEditingController();
  late TextEditingController _dateCompletedController = TextEditingController();
  late TaskStatus _status = TaskStatus.New;
  late List<ITag> tags = [];

  Future getTaskById() async {
    HttpHelper httpHelper = HttpHelper();
    // var result = await httpHelper.getTaskById(widget.taskId);
    var result = await TasksDatabase.instance.getTaskById(widget.taskId);
    // _taskId = result.taskId!;
    // _taskNameController.text = result.taskName;
    // _taskDescriptionController.text = result.taskDescription;
    // _dateCreatedController.text = result.dateCreated!;
    // _dateModifiedController.text = result.dateModified!;
    // _dateCompletedController.text = result.dateCompleted!;
    // _status = result.status;
    // setState(() {
    //   tags.addAll(result.tags!);
    // });
    _taskId = result.taskId!;
    _taskNameController.text = result.taskName;
    _taskDescriptionController.text = result.taskDescription;
    _dateCreatedController.text = result.dateCreated.toString();
    _dateModifiedController.text = result.dateModified.toString();
    _dateCompletedController.text = result.dateCompleted.toString();
    // _status = result.status;
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
                    message: 'Created at ${_dateCreatedController.text}',
                    child: _dateCompletedController.text.isEmpty
                        ? Text('Edited ${_dateModifiedController.text}')
                        : Text(
                            'Completed at ${_dateCompletedController.text}')),
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
    String dateCreated = _dateCreatedController.text.trim();
    String dateModified = _dateModifiedController.text.trim();

    ITask up = ITask(taskName, taskDescription, tags, _status);
    Task task = Task(
        taskName: taskName,
        taskDescription: taskDescription,
        dateCreated: DateTime.parse(dateCreated),
        dateModified: DateTime.now(),
        status: 0);

    HttpHelper helper = HttpHelper();
    // var result = await helper.updateTask(widget.taskId, up);
    // print(result.statusCode);
    var result = await TasksDatabase.instance.updateTask(task);
  }
}

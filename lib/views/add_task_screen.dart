import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_management_v2/data/database_helper.dart';
import 'package:task_management_v2/models/task.dart';
import 'package:task_management_v2/services/task_service_api.dart';
import 'package:task_management_v2/services/task_service_local.dart';
import 'package:task_management_v2/views/home_screen.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _tagController = TextEditingController();
  bool _taskNameHasError = false;
  bool _taskDescriptionHasError = false;
  final FocusNode _tagFocus = FocusNode();
  List<ITag> tags = [];
  final TaskServiceAPI _taskService = TaskServiceAPI();
  final TaskServiceLocal _taskServiceLocal = TaskServiceLocal();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Back')),
      body: SafeArea(
          child: ListView(
        children: [
          //start of text description
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Task',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Create your task by filling in the information below.',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff57636C)),
                        ))
                  ])),
          // end of text description
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
            child: Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          // start of task name
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: TextFormField(
                  controller: _taskNameController,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    setState(() {
                      _taskNameHasError = value.isEmpty ? true : false;
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 240, 243, 246),
                      border: OutlineInputBorder(),
                      enabledBorder: InputBorder.none,
                      suffixIcon: _taskNameHasError
                          ? const Icon(Icons.error, color: Color(0xffF1416C))
                          : const Icon(Icons.check, color: Colors.blue)))),
          // end of task name
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
            child: Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          // start of task description
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: TextFormField(
                  controller: _taskDescriptionController,
                  textInputAction: TextInputAction.next,
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      _taskDescriptionHasError = value.isEmpty ? true : false;
                    });
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 240, 243, 246),
                      border: OutlineInputBorder(),
                      enabledBorder: InputBorder.none,
                      suffixIcon: _taskDescriptionHasError
                          ? const Icon(Icons.error, color: Color(0xffF1416C))
                          : const Icon(Icons.check, color: Colors.blue)))),
          //end of task description
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 24),
            child: Text('Tags (Optional)',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          // start of tags
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: TextFormField(
                  controller: _tagController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    if (!_tagController.text.isEmpty) {
                      setState(() {
                        ITag tag = new ITag(tagName: '');
                        tag.tagName = _tagController.text.trim();
                        tags.add(tag);
                        _tagController.clear();
                        _tagFocus.unfocus();
                        FocusScope.of(context).requestFocus(_tagFocus);
                      });
                    }
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 240, 243, 246),
                    border: OutlineInputBorder(),
                    enabledBorder: InputBorder.none,
                  ))),
          //end of tags

          // start of chips for tags
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (var i = 0; i < tags.length; i++)
                      Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: InputChip(
                              label: Text(tags[i].tagName),
                              onDeleted: () {
                                setState(() {
                                  tags.removeAt(i);
                                });
                              }))
                  ]))),
          // end of chips for tags
          Divider(
            indent: 16,
            endIndent: 16,
          ),
// start of button
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Color(0xffF1FAFF),
                    backgroundColor: Color(0xff009EF7)),
                onPressed: () {
                  postTask();
                },
                child: const Text('Create',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xffF1FAFF))),
              ))
// end of button
        ],
      )),
    );
  }

  Future postTask() async {
    ITask newTask = ITask(
        taskName: _taskNameController.text.trim(),
        taskDescription: _taskDescriptionController.text.trim(),
        tags: tags,
        status: TaskStatus.New);

    // start of http
    http.Response result = await _taskService.postTask(newTask);
    if (result.statusCode == 201) {
      ITask localTask = ITask.fromJson(jsonDecode(result.body));
      setState(() {
        //add to local db
        _taskServiceLocal.postTask(localTask);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));

        showTopSnackBar(
            context,
            TopSnackBar(
              child: Card(
                child: ListTile(
                  title: Text('Task added successfully'),
                  leading: Icon(
                    Icons.check_circle,
                    color: Color(0xff50CD89),
                  ),
                ),
              ),
              onDismissed: () {},
              animationDuration: Duration(milliseconds: 550),
              reverseAnimationDuration: Duration(milliseconds: 550),
              displayDuration: Duration(milliseconds: 1250),
              padding: EdgeInsets.all(16),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linearToEaseOut,
              safeAreaValues: SafeAreaValues(),
            ));
      });
    }
  }
}

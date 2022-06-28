import 'package:flutter/material.dart';
import 'package:task_management_v2/data/task.dart';
import 'dart:convert';
import '../data/http_helper.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  final _tagController = TextEditingController();
  bool _taskNameHasError = false;
  bool _taskDescriptionHasError = false;
  final FocusNode _tagFocus = FocusNode();
  List<ITag> tagsList = [];
  late int serverResponse;
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
          // start of tagsList
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: TextFormField(
                  controller: _tagController,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (term) {
                    if (!_tagController.text.isEmpty) {
                      setState(() {
                        ITag tag = new ITag('');
                        tag.tagName = _tagController.text.trim();
                        tagsList.add(tag);
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
          //end of tagsList

          // start of chips for tagsList
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    for (var i = 0; i < tagsList.length; i++)
                      Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: InputChip(
                              label: Text(tagsList[i].tagName),
                              onDeleted: () {
                                setState(() {
                                  tagsList.removeAt(i);
                                });
                              }))
                  ]))),
          // end of chips for tagsList
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
                  if (serverResponse == 201) {
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Row(
                        children: [
                          Icon(Icons.check_circle),
                          Text('Task added successfully')
                        ],
                      ),
                      action: SnackBarAction(
                        label: 'OKAY',
                        onPressed: () {},
                      ),
                    );
                  }
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
    String taskName = _taskNameController.text.trim();
    String taskDescription = _taskDescriptionController.text.trim();
    List<ITag> tags = tagsList;
    ITask newTask = ITask(taskName, taskDescription, tags);

    HttpHelper helper = HttpHelper();
    var result = await helper.postTask(newTask);
    if (result.statusCode == 201) {
      setState(() {
        _taskNameController.clear();
        _taskDescriptionController.clear();
        _tagController.clear();
        tagsList.clear();
        serverResponse = result.statusCode;
      });
    }
  }
}

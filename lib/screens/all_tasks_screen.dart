import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_v2/screens/home_screen.dart';
import 'package:task_management_v2/screens/view_task_screen.dart';
import 'package:task_management_v2/shared/menu_bottom.dart';

import '../data/http_helper.dart';
import '../data/task.dart';

class AllTasks extends StatefulWidget {
  final List<ITask> tasks;
  final Function callbackFn;
  const AllTasks({required this.tasks, Key? key, required this.callbackFn})
      : super(key: key);

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Back'),
        ),
        bottomNavigationBar: MenuBottom(),
        body: ListView.builder(
          itemCount: widget.tasks.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Slidable(
                    // Specify a key if the Slidable is dismissible.
                    key: ValueKey(index),

                    // The start action pane is the one at the left or the top side.
                    startActionPane: ActionPane(
                      // A motion is a widget used to control how the pane animates.
                      motion: const ScrollMotion(),

                      // A pane can dismiss the Slidable.
                      dismissible: DismissiblePane(onDismissed: () {
                        setState(() {
                          deleteTask(widget.tasks[index].taskId!);
                          widget.tasks.removeAt(index);
                        });
                      }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: doNothing,
                          backgroundColor: Color(0xffFFF5F8),
                          foregroundColor: Color(0xffF1416C),
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        if (widget.tasks[index].status != TaskStatus.Completed)
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (value) =>
                                {updateTask(widget.tasks[index])},
                            backgroundColor: widget.tasks[index].status ==
                                    TaskStatus.InProgress
                                ? Color(0xffE8FFF3)
                                : Color(0xffFFF8DD),
                            foregroundColor: widget.tasks[index].status ==
                                    TaskStatus.InProgress
                                ? Color(0xff50CD89)
                                : Color(0xffFFC700),
                            icon: Icons.edit,
                            label: widget.tasks[index].status ==
                                    TaskStatus.InProgress
                                ? 'Completed'
                                : 'In Progress',
                          ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewTask(
                                    taskId: widget.tasks[index].taskId!,
                                  ))),
                      child: Card(
                        elevation: 0,
                        child: ListTile(
                            title: Text(
                              widget.tasks[index].taskName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Container(
                              height: 30,
                              width: 3,
                              decoration: BoxDecoration(
                                  color: _badgeTextColor(_statusConverter(
                                      widget.tasks[index].status)),
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            trailing: Badge(
                                elevation: 0,
                                toAnimate: false,
                                shape: BadgeShape.square,
                                badgeColor: _badgeColor(_statusConverter(
                                    widget.tasks[index].status)),
                                borderRadius: BorderRadius.circular(3),
                                badgeContent: Text(
                                  _statusConverter(widget.tasks[index].status),
                                  style: TextStyle(
                                      color: _badgeTextColor(_statusConverter(
                                          widget.tasks[index].status)),
                                      fontWeight: FontWeight.bold),
                                ))),
                      ),
                    )));
          },
        ));
  }

  _statusConverter(TaskStatus status) {
    String convertedStatus = 'New';
    switch (status) {
      case TaskStatus.New:
        convertedStatus = 'New';
        break;
      case TaskStatus.InProgress:
        convertedStatus = 'In Progress';
        break;
      case TaskStatus.Completed:
        convertedStatus = 'Completed';
        break;
      default:
        break;
    }
    return convertedStatus;
  }

  _badgeTextColor(String status) {
    Color color = Color(0xff009EF7);
    switch (status) {
      case 'New':
        color = Color(0xff009EF7);
        break;
      case 'In Progress':
        color = Color(0xffFFC700);
        break;
      case 'Completed':
        color = Color(0xff50CD89);
        break;
      default:
    }
    return color;
  }

  _badgeColor(String status) {
    Color color = Color(0xffF1FAFF);
    switch (status) {
      case 'New':
        color = Color(0xffF1FAFF);
        break;
      case 'In Progress':
        color = Color(0xffFFF8DD);
        break;
      case 'Completed':
        color = Color(0xffE8FFF3);
        break;
      default:
    }
    return color;
  }

  void doNothing(BuildContext context) {}

  Future deleteTask(String taskId) async {
    HttpHelper helper = HttpHelper();
    var result = await helper.deleteTask(taskId);
    if (result.statusCode == 201) {
      setState(() {
        // serverResponse = result.statusCode;
      });
    }
  }

  Future updateTask(ITask task) async {
    ITask up = ITask(
        task.taskName, task.taskDescription, task.tags, TaskStatus.InProgress);

    switch (task.status) {
      case TaskStatus.New:
        break;
      case TaskStatus.InProgress:
        up = ITask(task.taskName, task.taskDescription, task.tags,
            TaskStatus.Completed);
        break;
      case TaskStatus.Completed:
        break;
    }

    HttpHelper helper = HttpHelper();
    var result = await helper.updateTask(task.taskId!, up);
    if (result.statusCode == 200) {
      setState(() {
        widget.callbackFn();
      });
    }
  }
}

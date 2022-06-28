import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:badges/badges.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management_v2/screens/home_screen.dart';
import 'package:task_management_v2/shared/menu_bottom.dart';

import '../data/http_helper.dart';
import '../data/task.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({Key? key}) : super(key: key);

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
          itemCount: tasks.length,
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
                          deleteTask(tasks[index].taskId!);
                          tasks.removeAt(index);
                        });
                      }),

                      // All actions are defined in the children parameter.
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: doNothing,
                          backgroundColor: Color(0xffF1416C),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),

                    // The end action pane is the one at the right or the bottom side.
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          // An action can be bigger than the others.
                          flex: 2,
                          onPressed: doNothing,
                          backgroundColor: Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                      ],
                    ),

                    // The child of the Slidable is what the user sees when the
                    // component is not dragged.
                    child: Card(
                      child: ListTile(
                          title: Text(
                            tasks[index].taskName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          leading: Container(
                            height: 30,
                            width: 3,
                            decoration: BoxDecoration(
                                color: _badgeTextColor(tasks[index].status!),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          trailing: Badge(
                              elevation: 0,
                              toAnimate: false,
                              shape: BadgeShape.square,
                              badgeColor: _badgeColor(tasks[index].status!),
                              borderRadius: BorderRadius.circular(3),
                              badgeContent: Text(
                                tasks[index].status!,
                                style: TextStyle(
                                    color:
                                        _badgeTextColor(tasks[index].status!),
                                    fontWeight: FontWeight.bold),
                              ))),
                    )));
          },
        ));
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
}

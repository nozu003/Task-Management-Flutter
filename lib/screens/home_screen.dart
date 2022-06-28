import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:task_management_v2/data/task.dart';
import 'package:task_management_v2/shared/menu_bottom.dart';

import '../data/http_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late List<ITask> tasks = [];

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future getTasks() async {
      HttpHelper helper = HttpHelper();
      var result = await helper.getTasks();
      setState(() {
        for (var i = 0; i < result.length; i++) {
          tasks.add(result[i]);
        }
      });
    }

    // TODO: implement initState
    getTasks();
  }

  @override
  void dispose() {
    tasks.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double fontSize = 24;
    return Scaffold(
        appBar: AppBar(title: Text('Task Manager')),
        backgroundColor: Color(0xfff5f8fa),
        bottomNavigationBar: MenuBottom(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.pushNamed(context, '/create');
          },
          child: Icon(Icons.add),
        ),
        body: SafeArea(
            child: ListView(children: [
          Container(
              height: 650,
              // color: Colors.black,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Expanded(
                        child: Card(
                            elevation: 6,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: Color(0xffF8F5FF),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 330,
                                  child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Tasks'),
                                            ),
                                            Spacer(),
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.grid_view))
                                          ],
                                        ),
                                        SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(children: [
                                              for (var i = 0;
                                                  i < tasks.length;
                                                  i++)
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    height: 250,
                                                    width: 320,
                                                    child: Card(
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                color: _toDoColorsEnd(
                                                                    i),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child: Padding(
                                                                padding:
                                                                    const EdgeInsets.only(
                                                                        top: 10,
                                                                        left:
                                                                            10),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40,
                                                                            decoration:
                                                                                const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                          ),
                                                                          const Spacer(
                                                                            flex:
                                                                                1,
                                                                          ),
                                                                          PopupMenuButton(
                                                                            onSelected:
                                                                                (value) {
                                                                              switch (value) {
                                                                                case 'Update':
                                                                                  Navigator.pushNamed(context, '/update');
                                                                                  break;
                                                                                case 'Delete':
                                                                                  _onDeletePressed(i);
                                                                                  deleteTask(tasks[i].taskId!);
                                                                                  break;
                                                                              }
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              Icons.more_vert,
                                                                              color: _taskTextColor(i),
                                                                            ),
                                                                            itemBuilder: (BuildContext context) =>
                                                                                <PopupMenuEntry>[
                                                                              const PopupMenuItem(
                                                                                value: 'Update',
                                                                                child: ListTile(
                                                                                  title: Text('Update'),
                                                                                ),
                                                                              ),
                                                                              const PopupMenuItem(
                                                                                value: 'Delete',
                                                                                child: ListTile(
                                                                                  title: Text('Delete'),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          const Padding(
                                                                              padding: EdgeInsets.all(5)),
                                                                          Text(
                                                                            tasks[i].taskName,
                                                                            style:
                                                                                TextStyle(fontSize: fontSize, color: _taskTextColor(i)),
                                                                          ),
                                                                          Text(
                                                                              tasks[i].taskDescription,
                                                                              style: TextStyle(color: _taskTextColor(i))),
                                                                        ],
                                                                      ),
                                                                      Spacer(),
                                                                      Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom:
                                                                                  10.0),
                                                                          child:
                                                                              Row(children: [
                                                                            Badge(
                                                                                toAnimate: false,
                                                                                shape: BadgeShape.square,
                                                                                badgeColor: _toDoColorsStart(i),
                                                                                borderRadius: BorderRadius.circular(5),
                                                                                badgeContent: Row(children: [
                                                                                  Icon(Icons.calendar_month),
                                                                                  Padding(padding: EdgeInsets.only(left: 5)),
                                                                                  Text(tasks[i].dateCreated.toString(), style: TextStyle(color: Colors.black)),
                                                                                ]))
                                                                          ]))
                                                                    ])))))
                                            ]))
                                      ]))),
                              Container(
                                child: Expanded(
                                    child: Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Card(
                                        color: Color(0xffFFF8DD),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.pending_actions,
                                                size: 40,
                                                color: Color(0xffFFC700),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(5)),
                                              const Text('In-Progress Tasks',
                                                  style: TextStyle(
                                                      color: Color(0xffFFC700),
                                                      letterSpacing: .5,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Card(
                                        color: Color(0xffF1FAFF),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.fiber_new_rounded,
                                                size: 40,
                                                color: Color(0xff009EF7),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.all(5)),
                                              const Text('New Tasks',
                                                  style: TextStyle(
                                                      color: Color(0xff009EF7),
                                                      letterSpacing: .5,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                  ],
                                )),
                              ),
                              Container(
                                  child: Expanded(
                                      child: Row(children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.pushNamed(context, '/tasks'),
                                    child: Card(
                                      color: Color(0xffFFF5F8),
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.task,
                                              size: 40,
                                              color: Color(0xffF1416C),
                                            ),
                                            Padding(padding: EdgeInsets.all(5)),
                                            const Text('View Tasks',
                                                style: TextStyle(
                                                    color: Color(0xffF1416C),
                                                    letterSpacing: .5,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Card(
                                            color: Color(0xffE8FFF3),
                                            elevation: 0.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Icon(
                                                        Icons.check_circle,
                                                        size: 40,
                                                        color:
                                                            Color(0xff50CD89),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5)),
                                                      const Text(
                                                          'Completed Tasks',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff50CD89),
                                                              letterSpacing: .5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ])))))
                              ])))
                            ])))
                  ]))),
        ])));
  }

  _toDoColorsStart(int index) {
    Color startingColor = Color.fromARGB(100, 113, 57, 234);
    Color endingColor = Color(0xff7239EA);
    if (index % 2 == 0) {
      startingColor = Color.fromARGB(200, 255, 255, 255);
    }
    return startingColor;
  }

  _toDoColorsEnd(int index) {
    Color endingColor = Colors.white;
    if (index % 2 == 0) {
      endingColor = Color(0xff7239EA);
    }
    return endingColor;
  }

  _taskTextColor(int index) {
    Color text = Colors.black;
    if (index % 2 == 0) {
      text = Colors.white;
    }
    return text;
  }

  _onDeletePressed(int index) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: 'WARNING',
        desc: "Are you sure you want to delete the task?",
        btnOk: ElevatedButton(
          onPressed: () {
            setState(() {
              tasks.removeAt(index);
              Navigator.pop(context);
            });
          },
          child: const Text('YES'),
        ),
        btnCancel: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
          child: const Text('NO'),
        )).show();
  }

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

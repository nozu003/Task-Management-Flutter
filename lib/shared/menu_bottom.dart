import 'package:flutter/material.dart';
import 'package:task_management_v2/views/all_tasks_screen.dart';
import 'package:task_management_v2/views/home_screen.dart';

class MenuBottom extends StatelessWidget {
  const MenuBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.table_rows), label: 'Tasks')
    ]);
  }
}

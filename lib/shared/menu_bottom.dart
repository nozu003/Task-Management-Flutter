import 'package:flutter/material.dart';

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

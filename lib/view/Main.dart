import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nnlg/view/Main_course.dart';
import 'package:nnlg/view/Main_user.dart';
import 'package:nnlg/view/Main_water.dart';


class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  List<Widget> _viewList = [ Main_course(),Main_water(), Main_user()];
  int _index = 2;
  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined),label: '课表'),
    BottomNavigationBarItem(icon: Icon(Icons.water_drop),label: '打水'),
    BottomNavigationBarItem(icon: Icon(Icons.person),label: '账户')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _index,
        children: _viewList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: (c){
          setState((){
                _index = c;

              });
        },
        items: _itemList,
      ),
    );
  }
}

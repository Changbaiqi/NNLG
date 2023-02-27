import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nnlg/view/Main_community.dart';
import 'package:nnlg/view/Main_course.dart';
import 'package:nnlg/view/Main_user.dart';
import 'package:nnlg/view/Main_water.dart';

import '../utils/AccountUtil.dart';


class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  List<Widget> _viewList = [ Main_course(),Main_community(),Main_water(), Main_user()];
  int _index = 3;
  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined),label: '课表'),
    BottomNavigationBarItem(icon: Icon(Icons.bakery_dining),label: '社区'),
    BottomNavigationBarItem(icon: Icon(Icons.water_drop),label: '打水'),
    BottomNavigationBarItem(icon: Icon(Icons.person),label: '账户')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: _index,
        children: _viewList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
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

  @override
  void initState() {
    AccountUtil().onLinetoServer();
  }

}

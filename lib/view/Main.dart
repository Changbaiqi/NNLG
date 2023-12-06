
import 'package:flutter/material.dart';
import 'package:nnlg/view/Course_set.dart';
import 'package:nnlg/view/Main_community.dart';
import 'package:nnlg/view/Main_course.dart';
import 'package:nnlg/view/Main_user.dart';
import 'package:nnlg/view/Main_water.dart';
import 'package:nnlg/view/module/showNoticeDialog.dart';
import 'package:nnlg/view/module/showUpdateDialog.dart';

import '../utils/AccountUtil.dart';
import '../utils/edusys/Account.dart';


class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  List<Widget> _viewList = [Main_community(),Main_water(), Main_course(),Main_user(), Course_set(),];
  int _index = 2;
  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(icon: Icon(Icons.bakery_dining),label: '社区'),
    BottomNavigationBarItem(icon: Icon(Icons.water_drop),label: '打水'),
    BottomNavigationBarItem(icon: Icon(Icons.person),label: '账户'),
    BottomNavigationBarItem(icon: Icon(Icons.settings),label: '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,

      body: IndexedStack(
        index: _index,
        children: _viewList,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_month),
        backgroundColor: _index==2?Colors.blue:Colors.blueGrey,
        onPressed: () {
          _index=2;
          setState(() {});
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(500)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    blurRadius: 100,
                    spreadRadius: 1,
                    offset: Offset(0, 40))
              ]),
          child: BottomAppBar(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            height: 70,
            elevation: 0,
            color: Colors.transparent,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: (){_index=0;setState(() {});}, icon: Column(
                  children: [
                    Icon(Icons.bakery_dining,color: _index==0?Colors.blue:Colors.black,),
                    Text('主页',style: TextStyle(fontSize: 12),),
                  ],
                ),splashRadius: 27,padding: EdgeInsets.fromLTRB(0, 0, 0,0),),
                IconButton(onPressed: (){_index=1;setState(() {});}, icon: Column(
                  children: [
                    Icon(Icons.water_drop,color: _index==1?Colors.blue:Colors.black,),
                    Text('打水',style: TextStyle(fontSize: 12),),
                  ],
                ),splashRadius: 27,padding: EdgeInsets.fromLTRB(0, 0, 0,0),),
                Container(
                  width: 25,
                  height: 0,
                ),
                IconButton(onPressed: (){_index=3;setState(() {});}, icon: Column(
                  children: [
                    Icon(Icons.person,color: _index==3?Colors.blue:Colors.black,),
                    Text('账户',style: TextStyle(fontSize: 12),),
                  ],
                ),splashRadius: 27,padding: EdgeInsets.fromLTRB(0, 0, 0,0),),
                IconButton(onPressed: (){_index=4;setState(() {});}, icon: Column(
                  children: [
                    Icon(Icons.settings,color: _index==4?Colors.blue:Colors.black,),
                    Text('设置',style: TextStyle(fontSize: 12),),
                  ],
                ),splashRadius: 27,padding: EdgeInsets.fromLTRB(0, 0, 0,0),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    showNoticeDialog.autoDialog(context);
    showUpdateDialog.autoDialog(context);
    AccountUtil().onLinetoServer();
  }

}

import 'package:flutter/material.dart';
import 'package:nnlg/view/xiaobei/XiaoBei_Home.dart';
import 'package:nnlg/view/xiaobei/XiaoBei_User.dart';

class XiaoBei_Main extends StatefulWidget {
  const XiaoBei_Main({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Main> createState() => _XiaoBei_MainState();
}

class _XiaoBei_MainState extends State<XiaoBei_Main> {


  int _index = 1;
  List<Widget> _viewList = [
    XiaoBei_Home(),
    XiaoBei_User()
  ];
  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/Fun_off.png',width: 20,height: 20,),label: '功能',
      activeIcon: Image.asset('assets/images/Fun_on.png',width: 20,height: 20,)
    ),
    BottomNavigationBarItem(
        icon: Image.asset('assets/images/user_off.png',width: 20,height: 20,),label: '账号',
      activeIcon: Image.asset('assets/images/user_on.png',width: 20,height: 20,)
    )
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('小北自动打卡'),
      ),*/
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
        }, items: _itemList,
      ),
    );
  }
}


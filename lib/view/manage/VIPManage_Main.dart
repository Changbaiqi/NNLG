import 'package:flutter/material.dart';
import 'package:nnlg/view/manage/ManageXiaoBei_Main.dart';

class VIPManage_Main extends StatefulWidget {
  const VIPManage_Main({Key? key}) : super(key: key);

  @override
  State<VIPManage_Main> createState() => _VIPManage_MainState();
}

class _VIPManage_MainState extends State<VIPManage_Main> {
  
  int _index = 0;
  List<Widget> _viewList = [
    ManageXiaoBei_Main(),
    Text('')
  ];

  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: '小北'),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: '假条'),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("功能管理"),
      ),
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
        },items: _itemList,
      ),

    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nnlg/utils/VIPFunListUtil.dart';
import 'package:nnlg/view/manage/VIPManage_Main.dart';
import 'package:nnlg/view/xiaobei/XiaoBei_Main.dart';


class VIPFunList extends StatefulWidget {
  const VIPFunList({Key? key}) : super(key: key);

  @override
  State<VIPFunList> createState() => _VIPFunListState();
}

class _VIPFunListState extends State<VIPFunList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('VIP功能列表'),
            /*MaterialButton(
                child: Text(
                  "管理",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),),
                onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (builder){return VIPManage_Main();}));
                })*/
          ],
        ),
      ),
      body: VIPFunListMain(),
    );
  }
}


class VIPFunListMain extends StatefulWidget {
  const VIPFunListMain({Key? key}) : super(key: key);

  @override
  State<VIPFunListMain> createState() => _VIPFunListMainState();
}

class _VIPFunListMainState extends State<VIPFunListMain> {



  //子控件样式
  Widget childList(String title, String hint){
    return InkWell(
      child: Container(
        height: 70,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: [
                  Text('${title}',style: TextStyle(fontSize: 19,color: Colors.black87),),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: [
                  Text('${hint}',style: TextStyle(fontSize: 13,color: Colors.black45),)
                ],
              ),
            )

          ],
        ),
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (builder){
          return XiaoBei_Main();
        }));
      },
    );
  }


  List<Widget> funList = [

  ];


  addFunChild(){
    funList.add(childList('小北自动打卡','小北自动打卡功能'));
    //funList.add(childList('小北假条高仿', '瞒过门卫随意出行'));
  }



  @override
  Widget build(BuildContext context) {
    //addFunChild()

    return Container(
      child: ListView(
        children: funList,
      ),
    );
  }

  @override
  void initState() {
    addFunChild();

  }

}


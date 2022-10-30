import 'package:flutter/material.dart';
import 'package:nnlg/view/Main.dart';
import 'package:nnlg/view/manage/ManageXiaoBeiUserOperation.dart';

import '../../utils/ToastUtil.dart';

class ManageXiaoBei_Main extends StatefulWidget {
  const ManageXiaoBei_Main({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBei_Main> createState() => _ManageXiaoBei_MainState();
}

class _ManageXiaoBei_MainState extends State<ManageXiaoBei_Main> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ManageXiaoBei_Main_Card_1(),
            ManageXiaoBei_Main_Card_2(),
          ],
        ),
        ManageXiaoBei_Main_Card_3(),
        ManageXiaoBei_Main_Card_4()
      ],
    );
  }
  
}


/**
 * 小北打卡完成度
 */
class ManageXiaoBei_Main_Card_1 extends StatefulWidget {
  const ManageXiaoBei_Main_Card_1({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBei_Main_Card_1> createState() => _ManageXiaoBei_Main_Card_1State();
}

class _ManageXiaoBei_Main_Card_1State extends State<ManageXiaoBei_Main_Card_1> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width/2.4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("打卡完成度"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          value: 0.8,
                          strokeWidth: 6,
                        ),
                      ),
                      Text('30/50')
                    ],
                  ),),

              ],
            ),
          ),
        ),
      ),
      onTap: (){
        ToastUtil.show('功能暂未开放');
      },
    );
  }
}




/**
 * 小北打卡异常状况
 */

class ManageXiaoBei_Main_Card_2 extends StatefulWidget {
  const ManageXiaoBei_Main_Card_2({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBei_Main_Card_2> createState() => _ManageXiaoBei_Main_Card_2State();
}

class _ManageXiaoBei_Main_Card_2State extends State<ManageXiaoBei_Main_Card_2> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/5,
            width: MediaQuery.of(context).size.width/2.4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("打卡异常状态"),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          value: 0.8,
                          strokeWidth: 6,
                        ),
                      ),
                      Text('30/50')
                    ],
                  ),),

              ],
            ),
          ),
        ),
      ),
      onTap: (){
        ToastUtil.show('功能暂未开放');
      },
    );
  }
}


/**
 * 用户管理
 */

class ManageXiaoBei_Main_Card_3 extends StatefulWidget {
  const ManageXiaoBei_Main_Card_3({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBei_Main_Card_3> createState() => _ManageXiaoBei_Main_Card_3State();
}

class _ManageXiaoBei_Main_Card_3State extends State<ManageXiaoBei_Main_Card_3> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width/1,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('用户操作')
                    ],
                  ),),

              ],
            ),
          ),
        ),
      ),
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (builder){return ManageXiaoBeiUserOperation();}));
      },
    );
  }
}


/**
 * 一件全部打卡
 */
class ManageXiaoBei_Main_Card_4 extends StatefulWidget {
  const ManageXiaoBei_Main_Card_4({Key? key}) : super(key: key);

  @override
  State<ManageXiaoBei_Main_Card_4> createState() => _ManageXiaoBei_Main_Card_4State();
}

class _ManageXiaoBei_Main_Card_4State extends State<ManageXiaoBei_Main_Card_4> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width/1,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('一键全部打卡')
                    ],
                  ),),

              ],
            ),
          ),
        ),
      ),
      onTap: (){
        ToastUtil.show('功能暂未开放');
      },
    );
  }
}





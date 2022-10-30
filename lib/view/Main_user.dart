import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/MainUserUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/Course_set.dart';
import 'package:nnlg/view/Login.dart';
import 'package:nnlg/view/VIPFunList.dart';
import 'package:nnlg/view/XiaoBeiLeave.dart';

class Main_user extends StatefulWidget {
  const Main_user({Key? key}) : super(key: key);

  @override
  State<Main_user> createState() => _Main_userState();
}

class _Main_userState extends State<Main_user> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          User_Message(),
          User_set()
        ],
      ),
    );
  }

  @override
  void initState() {
    ToastUtil.show("长按头像进入VIP功能");
  }
}






class User_Message extends StatefulWidget {
  const User_Message({Key? key}) : super(key: key);

  @override
  State<User_Message> createState() => User_MessageState();
}


User_MessageState? user_messageState;
class User_MessageState extends State<User_Message> {

  //用于外部调用刷新
  void updateNull(){

    try{
      setState((){});
    }catch(e){

    }

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
      child: Card(
        child: Container(
          height: 440,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset('images/black.webp',fit: BoxFit.fill,
                    height: 220,width: MediaQuery.of(context).size.width,),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,

                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: ClipOval(
                          child: Image.asset('images/user.jpg',height: 130,width: 130,),
                        ),
                        onLongPress: (){
                          HapticFeedback.vibrate();
                          MainUserUtil().vipLogin('${LoginData.account}', '${LoginData.password}').then((value){
                            if( value["code"]==400){
                              ToastUtil.show('${value["msg"]}');
                              return;
                            }

                            if(value["code"]==200){
                              ContextDate.ContextVIPTken = value["token"];
                              Navigator.push(context, MaterialPageRoute(builder: (builder){
                                return VIPFunList();
                              }));
                            }
                          });

                          },
                      ),
                      Text('${AccountData.studentName}',style: TextStyle(fontSize: 20),)
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 330,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('学号：${AccountData.studentID}\n'),
                        Container(color: Colors.black12,width: MediaQuery.of(context).size.width,height: 1,),
                        Text('\n专业方向：${AccountData.studentMajor}')
                      ],
                    )),
                  )

            ],
          ),
        ),
      ),
    );
  }



  @override
  void initState() {
    user_messageState = this;
  }






}


class User_set extends StatefulWidget {
  const User_set({Key? key}) : super(key: key);

  @override
  State<User_set> createState() => _User_setState();
}

class _User_setState extends State<User_set> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        flex: 1,
        child: ListView(
          children: [
            Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text('课表设置',style: TextStyle(fontSize: 15),),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Image.asset('images/course.png',width: 25,height: 25,),
                            ),
                          ],
                        ),
                        onTap: (){
                          print('课表设置');
                          Navigator.of(context).push(MaterialPageRoute(builder: (builder){return Course_set();}));
                        },
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text('探索新版',style: TextStyle(fontSize: 15),),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Image.asset('images/bbgx.png',width: 29,height: 29,),
                            ),
                          ],
                        ),
                        onTap: (){
                          print('探索新版本');
                          ToastUtil.show('功能暂未开放');


                        },
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: Text('退出登录',style: TextStyle(fontSize: 15),),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Image.asset('images/backLogin.png',width: 25,height: 25,),
                            ),
                          ],
                        ),
                        onTap: (){
                          print('退出登录');

                          ShareDateUtil().clearAllAccountData();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (builder){
                                return Login();
                              }));

                        },
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child:
                  Center(
                    child: Text('         南宁理工学院 By.长白崎\n本软件为免费软件如有贩卖请勿相信\n作者QQ：2084069833',
                      style: TextStyle(fontSize: 13,color: Colors.black45),textAlign: TextAlign.center,
                    ),),)
              ],
            )
          ],
        ),
      ),
    );
  }
}


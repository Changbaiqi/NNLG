import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/view/Login.dart';
import 'package:nnlg/view/Main.dart';

import '../utils/ToastUtil.dart';
import 'Main_course.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {

    //toMain();
    //toLogin();




    return Scaffold(
      body: Center(
        child: Container(
          height: 230,
          width: 230,
          child: Image.asset('images/NNLG.png'),
        ),
      ),
    );
  }


  @override
  void initState() {

    //toMain();
    ShareDateUtil().initLoading().then((value){
      //print('${CourseData.nowWeek}');
      if(LoginData.autoLogin && LoginData.account.isNotEmpty && LoginData.password.isNotEmpty ){

        //自动登录用的
        LoginUtil.turnSubmit(LoginData.account,LoginData.password).then((value){
          //debugPrint(value);

          //记住账号密码
          LoginUtil().LoginPost(value).then((value){
            if(value==302){
              ToastUtil.show('登录成功');

              //进行完课表拉取后然后进行对应课表数据拉取刷新
              Future.wait([
                CourseUtil().getSemesterCourseList(),
                CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}")
              ]).then((value){
                course_listState!.updateNull();
              });



              toMain();
            }else{

              ToastUtil.show('登录失败，请检查一下账号或密码是否正确');
              toLogin();
            }
          });

        });







      }else{
        toLogin();
      }

    });

  }

  void toLogin()  {
    Timer timer = Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
        return Login();
      }));

      /*Navigator.of(context).push(MaterialPageRoute(builder: (builder){
        return Login();
      }));*/


    });
  }

  void toMain() {
    Timer timer = Timer(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder){
        return Main();
      }));
    });
  }
  

}

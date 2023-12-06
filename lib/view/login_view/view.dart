import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/MainUserUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/utils/edusys/Account.dart';
import 'package:nnlg/view/Main.dart';
import 'package:nnlg/view/Main_user.dart';

import 'logic.dart';

class LoginViewPage extends StatelessWidget {
  LoginViewPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginViewLogic>();
  final state = Get.find<LoginViewLogic>().state;

  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset('assets/images/NNLG.png',height: 150,width: 150,),
        ),
        inputAccount()
        ,
        inputPassword()
        ,
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: Row(
                      children: [
                        Checkbox(value: LoginData.rememberAccountAndPassword, onChanged: (v){
                          LoginData.rememberAccountAndPassword=(!LoginData.rememberAccountAndPassword);
                          ShareDateUtil().setRememberAccountAndPassword(LoginData.rememberAccountAndPassword);
                        }),
                        Text('记住账号密码')
                      ],
                    ),
                    onTap: () {

                        LoginData.rememberAccountAndPassword = !LoginData.rememberAccountAndPassword;
                      ShareDateUtil().setRememberAccountAndPassword(LoginData.rememberAccountAndPassword);
                    },
                  ),

                  InkWell(
                    child: Row(
                      children: [
                        Checkbox(value: LoginData.autoLogin, onChanged: (v){

                            LoginData.autoLogin=(!LoginData.autoLogin);

                          ShareDateUtil().setAutoLogin(LoginData.autoLogin);

                        }),
                        Text('自动登录')
                      ],
                    ),
                    onTap: (){

                        LoginData.autoLogin=(!LoginData.autoLogin);

                      ShareDateUtil().setAutoLogin(LoginData.autoLogin);
                    },
                  )

                ],
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                child: Text('登录'),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                    )
                ),
                onPressed: (){
                  new Account("21060231", "3838438778*ABCab").toLogin().then((value) {
                    print(value.session);
                    // value.getCourseList('2023-2024-1', 1).then((value){
                    //   print(value);
                    // });
                    // value.getAccountInfo().then((value){
                    //   debugPrint(value);
                    // });
                  });
                  //print('${_inputAccountController.text}');
                  //print('${_inputPasswordController.text}');
                  if(state.inputAccountController.value.text.isEmpty || state.inputAccountController.value.text.isEmpty){
                    ToastUtil.show('请输入正确的账号或密码！');
                    return;
                  }
                  try{



                    LoginUtil.turnSubmit(state.inputAccountController.value.text.toString(),state.inputPasswordController.value.text).then((value){
                      //debugPrint(value);

                      //记住账号密码
                      LoginUtil().LoginPost(value).then((value){
                        if(value==302){
                          ToastUtil.show('登录成功');
                          if(LoginData.rememberAccountAndPassword) {
                            ShareDateUtil().setLoginAccount(state.inputAccountController.value.text);
                            ShareDateUtil().setLoginPassword(state.inputPasswordController.value.text);

                          }

                          //用于获取账户信息并且存储到本地
                          AccountUtil().getAccountPersonalInformation().then((value) async {
                            print('${jsonDecode(value)['id']}');

                            await Future.wait([
                              ShareDateUtil().setAccountStudentID(jsonDecode(value)['id']),
                              ShareDateUtil().setAccountStudentName(jsonDecode(value)['name']),
                              ShareDateUtil().setAccountStudentMajor(jsonDecode(value)['major'])
                            ]).then((value){
                              //以上数据获取完后外部调用刷新界面
                              user_messageState?.updateNull();
                              //if(value!=null && (value is List)){

                              //}
                            });

                            CourseUtil().getSemesterCourseList().then((value){
                              //print('${CourseData.semesterCourseList[0]}');
                              //print('${value[0]}');
                              //如果以及寄存了课表的日期那么久直接返回
                              if(CourseData.nowCourseList!=null && CourseData.nowCourseList!="")
                                return;

                              ShareDateUtil().setNowCourseList(value[0]);
                            });

                            //这个使用服务器功能的登录
                            await MainUserUtil()
                                .vipLogin('${LoginData.account}',
                                '${LoginData.password}')
                                .then((value) {
                              if (value["code"] == 400) {
                                ToastUtil.show('${value["msg"]}');
                                return;
                              }

                              if (value["code"] == 200) {
                                ContextDate.ContextVIPTken = value["token"];
                              }
                            });

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (builder){
                                  return Main();
                                }));
                          });




                        }else{
                          ToastUtil.show('登录失败，请检查一下账号或密码是否正确');
                        }
                      });

                    });
                  }catch(e){
                    print(e);
                  }

                },
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("注",style: TextStyle(color: Colors.red,fontSize: 10),),
                Text("：账号和密码均为学校教务系统账号和密码",style: TextStyle(color: Colors.grey,fontSize: 11),)
              ],
            ),
          ),
        )
      ],
    );
  }





  Widget inputAccount(){
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
        child: Container(
          height: 55,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: state.inputAccountController.value,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    label: Text('账号'),
                    hintText: '请输入账号',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(100)
                        )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(100)
                        )
                    ),
                  ),
                  /*onChanged: (account){
                  _account = account;
                },*/),
              ),

            ],
          ),
        ),
      ),
    );

  }


  bool _seeNo_Off = true;
  List<Widget> _seelist = [Image.asset('assets/images/close_eye.png',height: 25,width: 25,),Image.asset('assets/images/open_eye.png',height: 25,width: 25,)];
  Widget inputPassword(){

    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
        child: Container(
          height: 55,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: state.inputPasswordController.value,
                  obscureText: _seeNo_Off,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    label: Text('密码'),
                    hintText: '请输入密码',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(100)
                        )
                    ),
                    suffixIcon: IconButton(
                        onPressed: (){
                          _seeNo_Off = !_seeNo_Off;
                        },
                        icon: _seelist[_seeNo_Off ? 0 : 1]),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(100)
                        )
                    ),
                  ),
                  /*onChanged: (password){
                    _password = password;
                  },*/
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}

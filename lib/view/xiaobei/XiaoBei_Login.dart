import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/utils/XiaoBeiLoginUtil.dart';


class XiaoBei_Login{

  BuildContext? _context;

  String? xiaobeiAccount;
  String? xiaobeiPassword;

  //小北账号输入框的控制
  TextEditingController accountTEC=TextEditingController();
  //小北密码输入框的控制
  TextEditingController passwordTEC =TextEditingController();

  List<Widget> _seelist = [Image.asset('images/close_eye.png',height: 25,width: 25,),Image.asset('images/open_eye.png',height: 25,width: 25,)];
  bool _seeNo_Off = true;


  XiaoBei_Login(context){
    _context = context;
  }

  //设置默认的小北账号和密码方便显示
  setDefaultActAndPws(String xiaobeiAccount , String xiaobeiPassowrd){
    this.xiaobeiAccount = xiaobeiAccount;
    this.xiaobeiPassword = xiaobeiPassword;
    accountTEC.text=xiaobeiAccount;
    passwordTEC.text=xiaobeiPassowrd;
  }



  Future bindAccountShow(){

    return showDialog(
        context: _context!,
        builder: (builder){
          return AlertDialog(
            title: Text("小北绑定"),
            content: Container(
              height: 150,
              child: Column(
                children: [
                  TextField(
                    controller: accountTEC,
                    decoration: InputDecoration(
                        hintText: "请输入小北账号",
                        labelText: "账号"
                    ),
                  ),
                  StatefulBuilder(builder: (BuildContext context,StateSetter setState){
                    return TextField(
                      obscureText: _seeNo_Off,
                      maxLines: 1,
                      controller: passwordTEC,
                      decoration: InputDecoration(
                          hintText: "请输入小北密码",
                          labelText: "密码",
                          suffixIcon: IconButton(
                            icon: _seelist[_seeNo_Off ? 0 : 1],
                            onPressed: (){
                              setState((){
                                _seeNo_Off = !_seeNo_Off;
                              }
                              );
                            },
                          )
                      ),
                    );
                  })

                ],
              ),
            ),
            actions: [
              MaterialButton(onPressed: (){Navigator.of(_context!).pop();},child: Text("取消"),),
              MaterialButton(onPressed: (){
                setXiaoBeiACTandPSW();
              },child: Text("绑定"),)
            ],
          );
        }
    );
  }


  setXiaoBeiACTandPSW(){
    XiaoBeiLoginUtil().setBindXiaoBeiAccountAndPassword(accountTEC.text, passwordTEC.text).then((value){
      if(value["code"]==400){
        ToastUtil.show(value["msg"]);
        return;
      }
      /*(value["code"]==200){
        Navigator.of(_context!).pop();
        ToastUtil.show("设置成功");
      }*/
      Navigator.of(_context!).pop(value);
    });
  }


  Future show(){

     return bindAccountShow();

  }


}

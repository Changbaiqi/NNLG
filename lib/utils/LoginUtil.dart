import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../dao/ContextData.dart';

class LoginUtil{



  BaseOptions _options = BaseOptions();


  LoginUtil(){
    _options.baseUrl ='${ContextDate.ContextUrl}';
  }



  //用于转换成加密的账号密码传输方式
  static Future<String> turnSubmit(String account,String password) async {
    MethodChannel platform = const MethodChannel("Login");

    String returnValue = await platform.invokeMethod('${account}--!--${password}');
    //print('${returnValue}');
    return returnValue;
  }


  //如果登录成功那么返回302，失败返回404
  Future<int> LoginPost(String encoded) async {

    int state = 404;

    try {
      Response response = await Dio(_options).request(
          '/gllgdxbwglxy_jsxsd/xk/LoginToXk?encoded=${encoded}',
          options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            receiveTimeout: 4000,
          ),
          data: {
            "encoded": '${encoded}'
          }
      );



    }on DioError catch(e){
      if(e.toString().length>60){
        //print('${e.toString().substring(53,56)}');
        if( (new RegExp(r"3\d\d")).hasMatch( e.toString().substring(53,56) )   ){
          state = 302;
          ContextDate.ContextCookie = e.response!.headers['set-cookie'].toString();
          //ToastUtil.show('登录成功');
        }else{
          //ToastUtil.show("登录失败");
        }
      }else{
        //ToastUtil.show("登录失败");
      }

    }

    return state;
  }

   toLogin(){

  }


}
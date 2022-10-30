
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';import 'package:flutter/services.dart';

import '../dao/ContextData.dart';

class AccountUtil{

  BaseOptions _options = BaseOptions();


  AccountUtil(){

    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }


  //http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/grxx/xsxx?Ves632DSdyV=NEW_XSD_XJCJ


//获取账号个人信息
  Future<dynamic> getAccountPersonalInformation() async {

    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/grxx/xsxx?Ves632DSdyV=NEW_XSD_XJCJ',
        options: Options(
          method: 'POST',
          contentType: 'application/x-www-form-urlencoded',
          receiveTimeout: 4000,
        ),
    );
    //debugPrint('${response}');
    //debugPrint('${response.data.toString()}');

    return getAccountHTMLToJSON(response.data.toString());
  }


  //用于提取账户个人信息页面并转换成JSON数据返回
  static Future<String> getAccountHTMLToJSON(String accountHTML) async {
    MethodChannel platform = const MethodChannel("AccountPOLO");

    String returnValue = await platform.invokeMethod('${accountHTML}');

    return returnValue;
  }




}
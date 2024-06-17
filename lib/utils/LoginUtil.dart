import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/edusys/tools/EncryEncode.dart';

import '../dao/ContextData.dart';

class LoginUtil {
  BaseOptions _options = BaseOptions();

  LoginUtil() {
    _options.method = 'POST';
    _options.baseUrl = '${ContextDate.ContextUrl}';
    _options.followRedirects = false;
    // _options.responseDecoder =gbkDecoder(responseBytes, options, responseBody)
    _options.validateStatus = (status) {
      return status! < 500;
    };
  }
  static String gbkDecoder(List<int> responseBytes, RequestOptions options, ResponseBody responseBody) {
    return gbk_bytes.decode(responseBytes);
  }

  //用于转换成加密的账号密码传输方式
  static Future<String> turnSubmit(String account, String password) async {
    // MethodChannel platform = const MethodChannel("Login");
    // String returnValue = await platform.invokeMethod('${account}--!--${password}');
    // log(returnValue);
    String result = EncryEncode.toEncodeInp(account, password);
    // log(result);
    // return returnValue;
    return result;
  }

  //如果登录成功那么返回302，失败返回404
  Future<Map<String, dynamic>> LoginPost(String encoded) async {
    // int state = 404;

    // try {
    Response response =
        await Dio(_options).request('/gllgdxbwglxy_jsxsd/xk/LoginToXk',
            options: Options(
              method: 'POST',
              contentType: 'application/x-www-form-urlencoded',
              responseDecoder: gbkDecoder
            ),
            data: {"encoded": '${encoded}'});

    // log(response.toString());
    // log(response.headers['set-cookie'].toString());
    RegExp regExp = RegExp(
        r'<font style="display: inline;white-space:nowrap;" color="red">([^<]+)</font>');
    RegExpMatch? match = regExp.firstMatch(response.data.toString());
    if (match != null) {
      return {'code': 400, 'msg': match.group(1).toString()};
    }

    return {
      'code': 200,
      'msg': '登录成功',
      'session': response.headers['set-cookie'].toString()
    };
  }

  /**
   * [title] 检测登录是否超时，如果超时那么从新登录
   * [author] 长白崎
   * [description] //TODO
   * [date] 21:27 2024/6/16
   * [param] null
   * [return]
   */
  static checkLoginTimeOut(Response response) async{
    String body =  gbk_bytes.decode(response.data);
    RegExp regExp = RegExp(
        r'<font style="display: inline;white-space:nowrap;" color="red">([^<]+)</font>');
    RegExpMatch? match = regExp.firstMatch(body);
    if(match!=null && match.group(1).toString().contains("请先登录系统")){
      await LoginUtil().LoginPost(EncryEncode.toEncodeInp(LoginData.account, LoginData.password)).then((value)async{
        if(value['code']==200){
          // LoginData.session = value['session'];
          ContextDate.ContextCookie = value['session'];
        }else{
          return false;
        }
      });
      return false;
    }
    return true;
  }

  toLogin() {}
}

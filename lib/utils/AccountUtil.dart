import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../dao/ContextData.dart';

class AccountUtil {
  BaseOptions _options = BaseOptions();

  AccountUtil() {
    _options.baseUrl = '${ContextDate.ContextUrl}';
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

  //用于后端记录上线
  Future<void> onLinetoServer() async {
    IOWebSocketChannel channel = IOWebSocketChannel.connect(
        '${ContextDate.VIPContextIpPort}/user/onLine/${AccountData.studentID}');
    channel.stream.listen((event) {
      print('${event}');
      var json = jsonDecode(event);
      ContextDate.onLineTotalCount.value = json['msg'];
    }, onError: (error) {
        channel.sink.close();
    }, onDone: () async {
        await onLinetoServer();
    });
  }


  /**
   * 提交点击量
   */
  Future<dynamic> toOnclickTotal() async {
    Response response = await Dio().request(
      '${ContextDate.VIPContextUrl}/user/toClick',
      options: Options(
        method: 'get',
        contentType: 'application/x-www-form-urlencoded',
        receiveTimeout: 4000,
      ),
    );
  }

  /**
   * 获取点击量
   */
  Future<dynamic> getOnclickTotal() async {
    Response response = await Dio().request(
      '${ContextDate.VIPContextUrl}/user/getClick',
      options: Options(
        method: 'get',
        receiveTimeout: 5000,
      ),
    );
    return response.data;
  }






}

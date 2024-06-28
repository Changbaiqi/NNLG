import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nnlg/utils/edusys/tools/AccountInfo.dart';
import 'package:nnlg/utils/edusys/tools/CourseNew.dart';
import 'package:nnlg/utils/edusys/tools/EncryEncode.dart';

class Account {
  String? _account;
  String? _password;
  String? _encryEncode;
  String? _session; //登录的SESSION

  Account(String account, String password) {
    this._account = account;
    this._password = password;
    this._encryEncode = EncryEncode.toEncodeInp(account, password);
  }


  String get session => _session??""; //登录
  Future<Account> toLogin() async {
    try {
      Response response = await Dio().request(
          'http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/xk/LoginToXk?encoded=${_encryEncode}',
          options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            receiveTimeout: const Duration(seconds: 15),
          ),
          data: {"encoded": '${_encryEncode}'});
    } on DioError catch (e) {
      if (e.toString().length > 60) {
        //print('${e.toString().substring(53,56)}');
        if ((new RegExp(r"3\d\d")).hasMatch(e.toString().substring(53, 56))) {
          this._session = e.response!.headers['set-cookie'].toString();
          //ToastUtil.show('登录成功');
        } else {
          //ToastUtil.show("登录失败");
        }
      } else {
        //ToastUtil.show("登录失败");
      }
    }

    return this;
  }

  /**
   * 获取获取指定学年的课表
   * @semester 指定学年
   * @week 指定学期
   */
  Future<String> getCourseList(String semester, int week) async {
    Response response = await Dio().request(
        'http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
        options: Options(
            method: 'POST',
            receiveTimeout: const Duration(seconds: 15),
            headers: {"Cookie": '$_session'}),
        data: {"xnxq01id": '${semester}', "zc": '$week'});
    // debugPrint(response.toString());
    CourseNew courseNew = CourseNew(response.toString());
    return courseNew.getAllJSON();
  }


  Future<String> getAccountInfo() async{
    Response response = await Dio().request(
        'http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/grxx/xsxx',
        options: Options(
            method: 'GET',
            receiveTimeout: const Duration(seconds: 15),
            headers: {"Cookie": '$_session'}));

    AccountInfo accountInfo =AccountInfo(response.toString());
    return accountInfo.getAllJSON();
  }
}

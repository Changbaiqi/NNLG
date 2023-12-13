import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/edusys/tools/TeachingEva.dart';

class TeachingEvaUtil{
  BaseOptions _options = BaseOptions();


  TeachingEvaUtil(){
    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }

  getTeachingEvaList() async{
    Response response = await Dio(_options).request(
      '/gllgdxbwglxy_jsxsd/xspj/xspj_find.do?Ves632DSdyV=NEW_XSD_JXPJ',
      options: Options(
        method: 'POST',
        contentType: 'application/x-www-form-urlencoded',
        receiveTimeout: 4000,
      ),
    );
    String str=response.data;
    TeachingEva(str).getTeachingEvaList();
  }


}
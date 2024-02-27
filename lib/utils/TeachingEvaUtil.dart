import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/edusys/entity/EvalInform.dart';
import 'package:nnlg/utils/edusys/entity/TeachingEvaForm.dart';
import 'package:nnlg/utils/edusys/tools/TeachingEva.dart';

class TeachingEvaUtil{
  BaseOptions _options = BaseOptions();


  TeachingEvaUtil(){
    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }

  /**
   * 获取评教列表
   */
  Future<List<TeachingEvaForm>> getTeachingEvaList() async{
    Response response = await Dio(_options).request(
      '/gllgdxbwglxy_jsxsd/xspj/xspj_find.do?Ves632DSdyV=NEW_XSD_JXPJ',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
      ),
    );
    String str=response.data;
    return TeachingEva(str).getTeachingEvaList();
  }

  /**
   * 获取评教项对应评教全部科目列表
   */
  Future<List<EvalInform>> getEvaDetailList(String url) async{
    Response response = await Dio(_options).request(
      '/${url}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
      ),
    );
    String str=response.data;
    return TeachingEva.getEvaDetailList(str);
  }

  /**
   * 获取对应应评教科目的评教表单
   */
  getEvaDetailForm(EvalInform evalInform) async{
    Response response = await Dio(_options).request(
      '/${evalInform.url}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
      ),
    );
    String HTML=response.data;
    TeachingEva.getEvaDetailForm(HTML);
  }

  /**
   * 获取评教项对应评教全部科目列表
   */
  Future<List<EvalInform>> submitEvaDetail(TeachingEvaForm teachingEvaForm) async{
    // http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/xspj/xspj_save.do
    Response response = await Dio(_options).request(
      '/${teachingEvaForm.evalUrl}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
      ),
    );
    String str=response.data;
    return TeachingEva.getEvaDetailList(str);
  }



}
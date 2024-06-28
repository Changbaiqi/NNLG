import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/edusys/entity/EvalInform.dart';
import 'package:nnlg/utils/edusys/entity/TeachingEvaForm.dart';
import 'package:nnlg/utils/edusys/tools/TeachingEva.dart';

import 'LoginUtil.dart';

class TeachingEvaUtil {
  BaseOptions _options = BaseOptions();

  TeachingEvaUtil() {
    _options.baseUrl = '${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;
  }

  /**
   * 获取评教列表
   */
  Future<List<TeachingEvaForm>> getTeachingEvaList() async {
    Response response = await Dio(_options).request(
      '/gllgdxbwglxy_jsxsd/xspj/xspj_find.do?Ves632DSdyV=NEW_XSD_JXPJ',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
        responseType: ResponseType.bytes,
      ),
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return TeachingEvaUtil().getTeachingEvaList();
    }
    String str = utf8.decode(response.data);
    return TeachingEva(str).getTeachingEvaList();
  }

  /**
   * 获取评教项对应评教全部科目列表
   */
  Future<List<EvalInform>> getEvaDetailList(String url) async {
    Response response = await Dio(_options).request(
      '/${url}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
        responseType: ResponseType.bytes,
      ),
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return TeachingEvaUtil().getEvaDetailList(url);
    }
    String str = utf8.decode(response.data);
    return TeachingEva.getEvaDetailList(str);
  }

  /**
   * 获取对应应评教科目的评教表单
   */
  Future<Map<String, dynamic>> getEvaDetailForm(EvalInform evalInform) async {
    Response response = await Dio(_options).request(
      '/${evalInform.url}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
        responseType: ResponseType.bytes,
      ),
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return TeachingEvaUtil().getEvaDetailForm(evalInform);
    }
    String HTML = utf8.decode(response.data);
    Map<String, dynamic> jsonMap = TeachingEva.getEvaDetailForm(HTML);
    return jsonMap;
  }

  /**
   * 获取评教项对应评教全部科目列表
   */
  Future<List<EvalInform>> submitEvaDetail(
      TeachingEvaForm teachingEvaForm) async {
    // http://bwgljw.yinghuaonline.com/gllgdxbwglxy_jsxsd/xspj/xspj_save.do
    Response response = await Dio(_options).request(
      '/${teachingEvaForm.evalUrl}',
      options: Options(
        method: 'GET',
        contentType: 'text/html;charset=UTF-8',
        responseType: ResponseType.bytes,
      ),
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return TeachingEvaUtil().submitEvaDetail(teachingEvaForm);
    }
    String str = utf8.decode(response.data);
    return TeachingEva.getEvaDetailList(str);
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 提交教评
   * [date] 1:23 2024/6/14
   * [param] null
   * [return]
   */
  Future<String?> submitEva(json,int subState/*提交状态0为保存，1为提交*/) async {
    String url = '/gllgdxbwglxy_jsxsd/xspj/xspj_save.do?';
    url+="pj09id=${json['pj09id']}&pj01id=${json['pj01id']}&pj0502id=${json['pj0502id']}&jg0101id=${json['jg0101id']}&jx0404id=${json['jx0404id']}&xsflid=${json['xsflid']}&xnxq01id=${json['xnxq01id']}&jx02id=${json['jx02id']}&pj02id=${json['pj02id']}";
    var data ={
      'pj09id': json['pj09id'],
      'pj01id': json['pj01id'],
      'pj0502id': json['pj0502id'],
      'jg0101id': json['jg0101id'],
      'jx0404id': json['jx0404id'],
      'xsflid': json['xsflid'],
      'xnxq01id': json['xnxq01id'],
      'jx02id': json['jx02id'],
      'pj02id': json['pj02id']
    };
    for(var classList in json['classList']){
      for(var problemList in classList['problemList']){
        data[problemList['titleName']] = problemList['titleValue'];
        url+='&${problemList['titleName']}=${problemList['titleValue']}';
        for(var selectList in problemList['selectList']){
          data[selectList['name']] = selectList['value'];
          url+='&${selectList['name']}=${selectList['value']}';
          if(selectList['checked']){ data[selectList['id']] = selectList['idValue']; url+='&${selectList['id']}=${selectList['idValue']}';}
        }
      }
    }
    url+='&issubmit=${subState}&ynr=&isxtjg=0';
    data['issubmit'] =0;
    data['ynr'] = null;
    data['isxtjg']= 0;

    Response response =
        await Dio(_options).request(url,
            options: Options(
              method: 'GET',
              contentType: 'application/x-www-form-urlencoded',
              responseType: ResponseType.bytes,
            ),
            // data: data
        );
    if(! await LoginUtil.checkLoginTimeOut(response)){
      return TeachingEvaUtil().submitEva(json, subState);
    }
    
    RegExp regExp=RegExp(r"alert\('([^']+)'\)");
    RegExpMatch? match = regExp.firstMatch(utf8.decode(response.data));
    if(match!=null){
      return match.group(1).toString();
    }
    return null;
    // log(response.toString());
  }

}

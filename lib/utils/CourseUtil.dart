
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/edusys/tools/CourseNew.dart';
import 'package:nnlg/utils/edusys/tools/EncryEncode.dart';
import 'package:nnlg/utils/edusys/tools/SemesterCourseList.dart';


class CourseUtil{


  BaseOptions _options = BaseOptions();


  CourseUtil(){

    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }



  //用于判断开学时间和现在时间的差距然后判断现在是第几周
  static int getNowWeek(String beginSchoolDate ,int ansWeek){

    int year = int.parse( beginSchoolDate.split("/")[0] );
    int month = int.parse( beginSchoolDate.split("/")[1] );
    int day = int.parse( beginSchoolDate.split("/")[2] );

    DateTime beginDate = DateTime(year,month,day);
    DateTime nowDate = DateTime.now();

    //开学第一日到如今一共经历了多少天
    int dif = nowDate.difference(beginDate).inDays+1;
    if(dif<=0){
      return 1;
    }
    if(dif>7*ansWeek){
      return ansWeek;
    }
    //print('计算页面为：${dif}');

    return dif%7==0 ? ((dif/7).toInt()) : ((dif/7).toInt()+1) ;


  }


  //根据学期与周数获取课表json
  Future<dynamic> getCourseWeekList(String semester,{int? week}) async {

    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
        options: Options(
          method: 'POST',
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.bytes,
        ),
        data: {
          "xnxq01id": '${semester}',
          "zc": '${week??""}'
        }
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return CourseUtil().getCourseWeekList(semester,week: week);
    }

    return toJSONCourse(utf8.decode(response.data));
  }




  //根据学期获取全部课表json并将其装载到课表数据存储
  Future<List<String>> getAllCourseWeekList(String semester) async {


    bool brushFlag = false;
    //暂时寄存
    List<String> resWeekCourseList = [];
    for(int week =1; week <= CourseData.ansWeek.value ; ++week){

      Response response = await Dio(_options).request(
          '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
          options: Options(
              method: 'POST',
              contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          ),
          data: {
            "xnxq01id": '${semester}',
            "zc": '${week}'
          }
      );
      //检查是否登录超时，如果超时则重新登录
      if(!brushFlag) {
        if (!await LoginUtil.checkLoginTimeOut(response)) {
          return CourseUtil().getAllCourseWeekList(semester);
        }
        brushFlag = true;
      }
      //debugPrint(response.toString());
      await toJSONCourse(utf8.decode(response.data)).then((value){
        //debugPrint(value);
        resWeekCourseList.add(value);


      });


    }

    return resWeekCourseList;

  }





  //从官网拉取学期课表的列表
  Future<dynamic> getSemesterCourseList() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.bytes,
        )
    );
    //检查是否登录超时，如果超时则重新登录
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return CourseUtil().getSemesterCourseList();
    }
    String body = utf8.decode(response.data);
    //debugPrint('${response.requestOptions.headers}');
    //debugPrint('${response}');
    List<String> resList = [];
    await toSemesterCourseList(body).then((value) async {

      List<dynamic> toList = jsonDecode(value);

      for( int i = 0 ; i < toList.length ; ++i ){
        resList.add(toList[i].toString());
      }
      await ShareDateUtil().setSemesterCourseList( resList );
    });

    return resList;

  }




  //将爬的网页转成JSON
  static Future<String> toJSONCourse(String courseHTML) async {
    // MethodChannel platform = const MethodChannel("CoursePOLO");
    // String oldReturnValue = await platform.invokeMethod('${courseHTML}');
    String returnValue =await CourseNew("${courseHTML}").getAllJSON();

    return returnValue;
  }

  //
  static Future<String> toSemesterCourseList(String semesterCourseListHTML) async {

    // MethodChannel platform = const MethodChannel("SemesterCourseListPOLO");
    // String returnValue = await platform.invokeMethod('${semesterCourseListHTML}');
    String returnValue=SemesterCourseList(semesterCourseListHTML).getAllList();
    return returnValue;

  }










}

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/edusys/tools/CourseNew.dart';


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
        ),
        data: {
          "xnxq01id": '${semester}',
          "zc": '${week??""}'
        }
    );
    //debugPrint('${response.requestOptions.headers}');
    //debugPrint('${response}');

    return toJSONCourse(response.toString());
  }




  //根据学期获取全部课表json并将其装载到课表数据存储
  Future<void> getAllCourseWeekList(String semester) async {


    //暂时寄存
    List<String> resWeekCourseList = [];
    for(int week =1 ; week <= CourseData.ansWeek.value ; ++week){


      Response response = await Dio(_options).request(
          '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
          options: Options(
              method: 'POST',
              contentType: 'application/x-www-form-urlencoded',
          ),
          data: {
            "xnxq01id": '${semester}',
            "zc": '${week}'
          }
      );
      //debugPrint(response.toString());
      await toJSONCourse(response.toString()).then((value){
        //debugPrint(value);
        resWeekCourseList.add(value);


      });


    }
    // int ans =0;
    // for(String str in resWeekCourseList){
    //   log("第${++ans}周课表"+str);
    // }


    //直接替换
    CourseData.weekCourseList.clear();
    CourseData.weekCourseList.value=resWeekCourseList;
    //存储到本地，将最新课表数据
    ShareDateUtil().setWeekCourseList(CourseData.weekCourseList.value);



  }





  //从官网拉取学期课表的列表
  Future<dynamic> getSemesterCourseList() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www-form-urlencoded',
        )
    );
    //debugPrint('${response.requestOptions.headers}');
    //debugPrint('${response}');
    List<String> resList = [];
    await toSemesterCourseList(response.toString()).then((value) async {

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
    MethodChannel platform = const MethodChannel("CoursePOLO");

    String returnValue = await platform.invokeMethod('${courseHTML}');
    // String returnValue =await CourseNew("${courseHTML}").getAllJSON();
    log(returnValue);
    //debugPrint('${returnValue}');
    return returnValue;
  }

  //
  static Future<String> toSemesterCourseList(String semesterCourseListHTML) async {

    MethodChannel platform = const MethodChannel("SemesterCourseListPOLO");
    //String returnValue = await platform.invokeMethod("450324200207311613--!--123");
    String returnValue = await platform.invokeMethod('${semesterCourseListHTML}');
    //debugPrint('${returnValue}');
    return returnValue;

  }










}
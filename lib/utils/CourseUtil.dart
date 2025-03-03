
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:callo/utils/edusys/entity/CourseForm.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/LoginUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/edusys/tools/CourseForAll.dart';
import 'package:callo/utils/edusys/tools/CourseNew.dart';
import 'package:callo/utils/edusys/tools/EncryEncode.dart';
import 'package:callo/utils/edusys/tools/SemesterCourseList.dart';


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

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 一次性直接获取课表
   * [date] 19:27 2024/7/15
   * [param] null
   * [return]
   */
  Future<String> getAllCourseSemesterList(String semester,int weekSum) async {
    bool brushFlag = false;
    // var resWeekCourseList={};
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
        options: Options(
          method: 'POST',
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.bytes,
        ),
        data: {
          "xnxq01id": '${semester}',
          "zc": ''
        }
    );
    //检查是否登录超时，如果超时则重新登录
    if(!brushFlag) {
      if (!await LoginUtil.checkLoginTimeOut(response)) {
        return CourseUtil().getAllCourseSemesterList(semester,weekSum);
      }
      brushFlag = true;
    }

    //判断是否有(全部)课程列表选项，如果没有，采用方案二
    // log(utf8.decode(response.data));
    if(!utf8.decode(response.data).contains('(全部)</option>')){
      return await getAllCourseSemesterListTwoPlain(semester,weekSum);
    }
    //debugPrint(response.toString());
    String newTest = await CourseForAll(utf8.decode(response.data)).getAllSemesterJson(weekSum);
    // log(newTest);
    // resWeekCourseList = jsonDecode(newTest);
    return newTest;
  }

  /**
   * [title] 一次性直接获取课表方案二（用于没有全部课表选项的情况）
   * [author] 长白崎
   * [description] //TODO
   * [date] 0:05 2025/3/3
   * [param] null
   * [return] 
   */
  Future<String> getAllCourseSemesterListTwoPlain(String semester,int weekSum) async{

    List<List<List<CourseForm?>>> list = [];
    HashSet<String> equRes=HashSet();

    for(int i=1;i<=weekSum;++i){
      Response response = await Dio(_options).request(
          '/gllgdxbwglxy_jsxsd/xskb/xskb_list.do',
          options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes,
          ),
          data: {
            "xnxq01id": '${semester}',
            "zc": '${i}'
          }
      );
      String json =CourseForAll(utf8.decode(response.data)).getAllSemesterJson(weekSum);
      if(equRes.contains(json)) continue; //过滤有过的课表数据
      equRes.add(json); //添加Set里面用于去重

      List<List<List<CourseForm?>>> resList =CourseForAll(utf8.decode(response.data)).getCourFormList();
      if(list.length==0){ list = resList; continue;} //如果列表长度为一那么就是初始状态列表，那么就直接赋值即可
      for(int j =0;j<list.length;++j){
        for(int z = 0;z<list[j].length;++z){
          for(int t = 0; t<resList[j][z].length;++t){
            if(resList[j][z][t]==null) continue;
            bool flag = true;
            for(int t1 = 0; t1<list[j][z].length;++t1) {
              if(list[j][z][t1]==null) continue;
              if (resList[j][z][t]!.courseName==list[j][z][t1]!.courseName &&
                  resList[j][z][t]!.courseClassRoom==list[j][z][t1]!.courseClassRoom &&
                  resList[j][z][t]!.courseTeacher==list[j][z][t1]!.courseTeacher &&
                  resList[j][z][t]!.courseWeek==list[j][z][t1]!.courseWeek) {
                flag = false;
                continue;
              }
            }
            if(flag) list[j][z].add(resList[j][z][t]);
          }
        }
      }
    }
    String json =CourseForAll.listTurnAllSemesterJson(list, weekSum);
    log(json);
    return json;
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
    // String newTest = await CourseForAll("${courseHTML}").getAllSemesterJson(21);
    // log(newTest);
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
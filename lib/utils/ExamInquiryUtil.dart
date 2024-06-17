import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../dao/ContextData.dart';
import 'LoginUtil.dart';

class ExamInquiryUtil{



  BaseOptions _options = BaseOptions();


  ExamInquiryUtil(){

    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }



  //获取成绩时间列表
  Future<List<String>> getReportCardQueryList() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xsks/xsksap_query',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www.form-urlencoded',
          receiveTimeout: 4000
        )
    );
    if(await LoginUtil.checkLoginTimeOut(response)){
      return getReportCardQueryList();
    }

    var text = '<select id="kksj" name="kksj" style="width: 170px;">测试用的text</select>';
    RegExp selectExp = RegExp(r'<select id="xnxqid" name="xnxqid" style="width: 170px;">([\s\S]*?)</select>');
    RegExpMatch? test= selectExp.firstMatch(response.toString());
    // debugPrint(response.toString());
    List<String> timeList = [];
    if(test!=null){
      RegExp optionValue = RegExp(r'>([\s\S]*?)</option>');
      Iterable<Match> tecc = optionValue.allMatches(test.group(1).toString());
      for(Match m in tecc){
        String match = m.group(1).toString();
        //print(match);
        timeList.add(match);
      }
    }
    return timeList;
  }

  //获取官网现在所默认选择的日期
  Future<String> getExamNowSelectTime() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xsks/xsksap_query',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www.form-urlencoded',
          receiveTimeout: 4000
        )
    );
    //检查是否登录超时，如果超时则重新登录
    if(await LoginUtil.checkLoginTimeOut(response)){
      return getExamNowSelectTime();
    }
    //<option selected value="2022-2023-2">2022-2023-2</option>
    //var text = '<select id="kksj" name="kksj" style="width: 170px;">测试用的text</select>';
    RegExp selectExp = RegExp(r'<select id="xnxqid" name="xnxqid" style="width: 170px;">([\s\S]*?)</select>');
    RegExpMatch? test= selectExp.firstMatch(response.toString());
    //debugPrint(response.toString());
    if(test!=null){
      String text = test.group(1).toString();
      RegExp optionValue = RegExp(r'<option selected value="[^<]*">([^<]*)*?</option>');
      //print(text);
      RegExpMatch? selectTime= optionValue.firstMatch(text);
      //print(selectTime!.group(1).toString());
      return selectTime!.group(1).toString();
      //return selectTime!.group(2).toString();
    }
    return "";
  }

  //根据参数获取成绩列表
  Future<List<String>> getExamList(String time) async{
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/xsks/xsksap_list',
        options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            receiveTimeout: 4000,
        ),
        data: {
          "xqlbmc": '',
          "xnxqid": '${time}',
          "xqlb": '',
        }
    );
    //检查是否登录超时，如果超时则重新登录
    if(await LoginUtil.checkLoginTimeOut(response)){
      return getExamList(time);
    }
    //debugPrint(response.data);

    RegExp scoreExpText = RegExp(r'class="Nsb_r_list Nsb_table">([\s\S]*?)</table>');
    String? text = scoreExpText.firstMatch(response.toString())?.group(1).toString();
    RegExp scoreExpTR = RegExp(r'<tr>([\s\S]*?)</tr>');
    //debugPrint(scoreExpTR.firstMatch(response.toString())?.group(1).toString());
    Iterable<Match> tecc = scoreExpTR.allMatches(text??"");
    List<String> scoreList = [];
    for(Match m in tecc){
      String match = m.group(1).toString();
      //debugPrint(match);
      RegExp examRxp = RegExp(r'<td>([\d]*)</td>[^<]*<td align="left">([^>]*)</td>[^<]*<td align="left">([^>]*)</td>[^<]*<td align="left">([^>]*)</td>[^<]*<td>([^<]*)</td>[^<]*<td>([^<]*)</td>[^<]*<td>([^<]*)</td>[^<]*<td>([^<]*)</td>');
      //序号，考试场次，课程编号，课程名称，考试时间，考场，座位号，准考证号
      String? number = examRxp.firstMatch(match)?.group(1).toString();
      String? session = examRxp.firstMatch(match)?.group(2).toString();
      String? courseNumber = examRxp.firstMatch(match)?.group(3).toString();
      String? courseName = examRxp.firstMatch(match)?.group(4).toString();
      String? examTime = examRxp.firstMatch(match)?.group(5).toString();
      String? examRoom = examRxp.firstMatch(match)?.group(6).toString();
      String? seatNumber = examRxp.firstMatch(match)?.group(7).toString();

      //过滤不合格
      if(number==null ||
      session==null ||
      courseNumber==null ||
      courseName== null ||
      examTime==null ||
      examRoom==null ||
      seatNumber==null)
        continue;

      String json = '{"number": "${number}",'
          '"session":"${session}",'
          '"courseNumber": "${courseNumber}",'
          '"courseName":"${courseName}",'
          '"examTime":"${examTime}",'
          '"examRoom":"${examRoom}",'
          '"seatNumber":"${seatNumber}"'
          '}';
      //debugPrint(json);
      scoreList.add(json);
    }
    return scoreList;
  }


}
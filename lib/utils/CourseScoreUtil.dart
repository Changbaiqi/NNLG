import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';

import '../dao/ContextData.dart';
import 'LoginUtil.dart';

class CourseScoreUtil {
  BaseOptions _options = BaseOptions();

  CourseScoreUtil() {
    _options.baseUrl = '${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;
  }

  //获取成绩时间列表
  Future<List<String>> getReportCardQueryList() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/kscj/cjcx_query',
        options: Options(
            method: 'GET',
            contentType: 'application/x-www.form-urlencoded',
            responseType: ResponseType.bytes,
        ));
    //检查是否登录超时，如果超时则重新登录
    if (!await LoginUtil.checkLoginTimeOut(response)) {
      return getReportCardQueryList();
    }
    // log(utf8.decode(response.data));

    var text =
        '<select id="kksj" name="kksj" style="width: 170px;">测试用的text</select>';
    RegExp selectExp = RegExp(
        r'<select id="kksj" name="kksj" style="width: 170px;">([\s\S]*?)</select>');
    RegExpMatch? test = selectExp.firstMatch(utf8.decode(response.data));
    //debugPrint(response.toString());
    List<String> timeList = [];
    if (test != null) {
      RegExp optionValue = RegExp(r'>([\s\S]*?)</option>');
      Iterable<Match> tecc = optionValue.allMatches(test.group(1).toString());
      for (Match m in tecc) {
        String match = m.group(1).toString();
        //print(match);
        timeList.add(match);
      }
    }

    return timeList;
  }

  //根据参数获取成绩列表
  Future<List<String>> getScoreList(String time) async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/kscj/cjcx_list',
        options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.bytes
        ),
        data: {"kksj": '${time}', "kcxz": '', "kcmc": '', "xsfs": 'all'});
    //检查是否登录超时，如果超时则重新登录
    if (!await LoginUtil.checkLoginTimeOut(response)) {
      return getScoreList(time);
    }
    // log(response.toString());
    //debugPrint(response.data);
    RegExp scoreExpTR = RegExp(r'<tr>([\s\S]*?)</tr>');
    Iterable<Match> tecc = scoreExpTR.allMatches(utf8.decode(response.data,allowMalformed: true));
    List<String> scoreList = [];
    for (Match m in tecc) {
      String match = m.group(1).toString();
      RegExp courseNumberExp = RegExp(
          r'<td>([\d]*)</td>[\n\s]*<td>([^<]*)*?</td>[\n\s]*<td align="left">([\d]{4,})?</td>[\n\s]*<td align="left">([^<]*)*?</td>');
      RegExp courseCsoreExp = RegExp(r'<td style="[^"]*">([\s\S]*)</td></td>');

      //序号
      String? number = courseNumberExp.firstMatch(match)?.group(1).toString();
      String? time = courseNumberExp.firstMatch(match)?.group(2).toString();
      //课程编号
      String? courseNumber =
          courseNumberExp.firstMatch(match)?.group(3).toString();
      //课程名称
      String? courseName =
          courseNumberExp.firstMatch(match)?.group(4).toString();
      //课程成绩
      String? courseScore =
          courseCsoreExp.firstMatch(match)?.group(1).toString();

      if (courseNumber == null) continue;
      if (courseName == null) continue;
      if (courseScore == null) continue;
      scoreList.add(
          '{"number":"${number}","time":"${time}","courseNumber":"${courseNumber}","courseName":"${courseName}","courseScore":"${courseScore}"}');
    }
    return scoreList;
  }
}

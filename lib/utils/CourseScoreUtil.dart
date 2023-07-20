
import 'package:dio/dio.dart';

import '../dao/ContextData.dart';

class CourseScoreUtil{



  BaseOptions _options = BaseOptions();


  CourseScoreUtil(){

    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;

  }



  //获取成绩时间列表
  Future<List<String>> getReportCardQueryList() async {
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/kscj/cjcx_query',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www.form-urlencoded',
          receiveTimeout: 4000,
        )
    );
    var text = '<select id="kksj" name="kksj" style="width: 170px;">测试用的text</select>';
    RegExp selectExp = RegExp(r'<select id="kksj" name="kksj" style="width: 170px;">([\s\S]*?)</select>');
    RegExpMatch? test= selectExp.firstMatch(response.toString());
    //debugPrint(response.toString());
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

  //根据参数获取成绩列表
  Future<List<String>> getScoreList(String time) async{
    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/kscj/cjcx_list',
        options: Options(
            method: 'POST',
            contentType: 'application/x-www-form-urlencoded',
            receiveTimeout: 4000
        ),
        data: {
          "kksj": '${time}',
          "kcxz": '',
          "kcmc": '',
          "xsfs": 'all'
        }
    );
    //debugPrint(response.data);
    RegExp scoreExpTR = RegExp(r'<tr>([\s\S]*?)</tr>');
    Iterable<Match> tecc = scoreExpTR.allMatches(response.toString());
    List<String> scoreList = [];
    for(Match m in tecc){
      String match = m.group(1).toString();
      RegExp courseNumberExp = RegExp(r'<td>([\d]*)</td>[\n\s]*<td>([^<]*)*?</td>[\n\s]*<td align="left">([\d]{4,})?</td>[\n\s]*<td align="left">([^<]*)*?</td>');
      RegExp courseCsoreExp = RegExp(r'<td style="[^"]*">([\s\S]*)</td></td>');

      //序号
      String? number = courseNumberExp.firstMatch(match)?.group(1).toString();
      String? time = courseNumberExp.firstMatch(match)?.group(2).toString();
      //课程编号
      String? courseNumber = courseNumberExp.firstMatch(match)?.group(3).toString();
      //课程名称
      String? courseName = courseNumberExp.firstMatch(match)?.group(4).toString();
      //课程成绩
      String? courseScore =courseCsoreExp.firstMatch(match)?.group(1).toString();

      if(courseNumber==null)
        continue;
      if(courseName==null)
        continue;
      if(courseScore==null)
        continue;
      scoreList.add('{"number":"${number}","time":"${time}","courseNumber":"${courseNumber}","courseName":"${courseName}","courseScore":"${courseScore}"}');
    }
    return scoreList;
  }



}
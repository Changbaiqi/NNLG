
import 'dart:collection';
import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:nnlg/utils/edusys/entity/EvalInform.dart';
import 'package:nnlg/utils/edusys/entity/TeachingEvaForm.dart';

class TeachingEva{
  String? _teachingEvaluationHTML;
  TeachingEva(this._teachingEvaluationHTML);

  /**
   * 获取评教列表
   */
  List<TeachingEvaForm> getTeachingEvaList(){
    RegExp regExp1 = RegExp(r'<tr>[^<]+<td>[\D]*([\d]+)[\D]*</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td[^>]+>[^<]+<!--[^\[]+\[<a href="[^"]+" title="点击进入评价">学生网上评教</a>\][^-]+-->[^<]+<a href="([^"]+)" title="点击进入评价">进入评价</a>[^<]+</td>[^<]+</tr>');
    Iterable<Match> match1 = regExp1.allMatches(_teachingEvaluationHTML!);

    List<TeachingEvaForm> evalForms = [];
    for(Match m in match1){
      var xh =m.group(1);//序号
      var xn = m.group(2);// 学年
      var pjfl = m.group(3); //评价分类
      var pjpc = m.group(4); //评价批次
      var kssj = m.group(5); //开始时间
      var jssj = m.group(6); //结束时间
      var pjurl = m.group(7);//评教网址
      evalForms.add(TeachingEvaForm(number: xh,schoolYear: xn,evalClass: pjfl,evalBatch: pjpc,evalStartTime: kssj,evalEndTime: jssj,evalUrl: pjurl));
    }
    return evalForms;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 获取评教项目中所有评价课程
   * [date] 19:13 2024/6/13
   * [param] null
   * [return]
   */
  static List<EvalInform> getEvaDetailList(String HTML){
    RegExp regExp1 = RegExp(r'<tr>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>[^\[]+\[<a href="([^"]+)">[^<]*</a>\][^<]+</td>[^<]+</tr>');
    Iterable<Match> match1 = regExp1.allMatches(HTML);
    List<EvalInform> evalForms = [];
    for(Match m in match1){
      print('');
      var number =m.group(1);//序号
      var courseNumber = m.group(2); //课程编号
      var courseName = m.group(3); //课程名称
      var teacher = m.group(4); //授课老师
      var evalType = m.group(5); //评教类型
      var overallScore = m.group(6); //总分
      var isRated = m.group(7); //是否已评
      var isSubmit = m.group(8); //是否提交
      var url = m.group(9); //打分网址
      evalForms.add(EvalInform(number: number, courseNumber: courseNumber,courseName: courseName,teacher: teacher,evalType: evalType,overallScore: overallScore,isRated: isRated,isSubmit: isSubmit,url: url));
    }
    return evalForms;
  }

  //获取老师评价表单
  static getEvaDetailForm(String HTML){
    HTML = HTML.replaceAll("&nbsp;", " ");
    // List<Map<String,dynamic>> jsonList =[];
    Map<String,dynamic> jsonMap = {};

    RegExp regExpHead = RegExp(r'<th class="Nsb_r_list_thb">[\s]*课程名称：([^\s]+)[^评]*评教大类：([^\s]+)[^总]*总评分: ([^\s]+)[^<]*</th>');
    Iterable<Match> matchHead = regExpHead.allMatches(HTML);
    for(Match m in matchHead){
      var courseName = m.group(1); //课程名称
      var evalClass = m.group(2); //评价类别
      var overallScore = m.group(3); //总评分
      // print(courseName);
    }

    RegExp regExp1 = RegExp(r'<form method="post" name="Form1" id="Form1" action="([^"]+)" target="ifrmHidden">[^<]+<input type="hidden" name="issubmit" id="issubmit" value="([^"]+)" />[^<]+<input type="hidden" name="pj09id" value="([^"]+)" />[^<]+<input type="hidden" name="pj01id" value="([^"]+)" />[^<]+<input type="hidden" name="pj0502id" value="([^"]+)" />[^<]+<input type="hidden" name="jg0101id" value="([^"]+)" />[^<]+<input type="hidden" name="jx0404id" value="([^"]*)" />[^<]+<input type="hidden" name="xsflid" value="([^"]*)" />[^<]+<input type="hidden" name="xnxq01id" value="([^"]*)" />[^<]+<input type="hidden" name="jx02id" value="([^"]*)" />[^<]+<input type="hidden" name="pj02id" value="([^"]*)" />');
    Iterable<Match> match1 = regExp1.allMatches(HTML);
    for(Match m in match1){
      var url = m.group(1);
      var issubmit = m.group(2); //是否提交状态
      var pj09id = m.group(3);
      var pj01id = m.group(4);
      var pj0502id = m.group(5);
      var jg0101id = m.group(6);
      var jx0404id = m.group(7);
      var xsflid = m.group(8); ///学生fl
      var xnxq01id = m.group(9); //学年学期
      var jx02id = m.group(10);
      var pj02id = m.group(11);
      jsonMap['pj09id'] = pj09id;
      jsonMap['pj01id']=pj01id;
      jsonMap['pj0502id'] = pj0502id;
      jsonMap['jg0101id'] = jg0101id;
      jsonMap['jx0404id'] = jx0404id;
      jsonMap['xsflid'] = xsflid;
      jsonMap['xnxq01id'] = xnxq01id;
      jsonMap['jx02id'] = jx02id;
      jsonMap['pj02id'] = pj02id;
    }
    jsonMap['classList'] = [];

    RegExp regExp2 = RegExp(r'<table id="table1" cellspacing="0" class="Nsb_r_list Nsb_table">([\s\S]+?)</table>');
    Iterable<Match> match2 = regExp2.allMatches(HTML);
    for(Match m in match2){
      String contentForm = m.group(1).toString();
      RegExp regExp3 = RegExp(r'<tr>([\s\S]*?)</tr>');
      Iterable<Match> match3 = regExp3.allMatches(contentForm);

      int classAns =-1;
      int ansSelect =0;
      for(Match m in match3){
        String trContent = m.group(0).toString();
        // log(m.group(1).toString()); //一阶段截取

        //如果是大类标签
        RegExp regExp4 = RegExp(r'<td colspan="2" align="left">[^(]*([^（]*)（<font color="red">([^<]*)</font>）');
        if(regExp4.hasMatch(trContent)){
          RegExpMatch? matchClass= regExp4.firstMatch(trContent);
          String titleContent = matchClass!.group(1).toString();
          String rateContent = matchClass!.group(2).toString();
          log(titleContent);
          log(rateContent);
          ++classAns;
          jsonMap['classList'].add({'className': titleContent,'rate': rateContent,'problemList':[]});
          ansSelect=0;
          continue; //直接跳过后面的
        }

        //如果是题目
        RegExp regExp5 = RegExp(r'<tr>[^<]*<td>([\s\S]+)</td>[^<]*<td>([\s\S]+?)</td>[^<]*?</tr>');
        if(regExp5.hasMatch(trContent)){
          RegExpMatch? matchClass= regExp5.firstMatch(trContent);
          String title = matchClass!.group(1).toString(); //评教内容名称
          String selects = matchClass!.group(2).toString(); //评教评分选项

          RegExp regExpTitle = RegExp(r'([^<]*)<input type="[^"]*" name="([^"]+)" value="([^"]+)">');
          RegExpMatch? matchTitle= regExpTitle.firstMatch(title);
          String titleContent = matchTitle!.group(1).toString(); //具体标题内容
          String titleName = matchTitle!.group(2).toString(); //titleName
          String titleValue = matchTitle!.group(3).toString(); //titleValue
          (jsonMap['classList'][classAns]['problemList'] as List).add({'title': titleContent,'titleName': titleName,'titleValue': titleValue,'selectList':[]});



          RegExp regExpSelects = RegExp(r'<input type="radio" name="([^"]+)" id="[^"]+"[^v]*value="([^"]+)" (checked="checked")*>([^<]+)<input type="[^"]+" name="([^"]+)" value="([^"]+)">');
          Iterable<Match> matchSelects = regExpSelects.allMatches(selects);
          for(Match m in matchSelects){
            // String? ccc = m.group(1).toString();
            // log('输出内容：：：'+ccc);
            ((jsonMap['classList'][classAns]['problemList'] as List)[ansSelect]['selectList'] as List).add({'id': m.group(1).toString(),'idValue': m.group(2).toString(),'checked':  m.group(3).toString()=="null"?false:true,'text': m.group(4).toString(),'name': m.group(5).toString(),'value': m.group(6).toString()});
          }
          ++ansSelect;
          continue; //直接跳过后面的
        }
      }
      break;
    }
    log(jsonMap.toString());

    return jsonMap;

    //
    // RegExp regExpForm = RegExp(r'<tr>[^<]*<td colspan="2" align="left">[^(]*\([^)]*\) ([^（]+)（<font color="red">([^<]+)</font>）([\s\S]+)<tr>[\s]*<td colspan="2"');
    // Iterable<Match> matchForm = regExpForm.allMatches(HTML);
    // for(Match m in matchForm){
    //   print(m.group(1));
    // }


   }

}
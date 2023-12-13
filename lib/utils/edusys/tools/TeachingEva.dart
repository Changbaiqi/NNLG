
import 'package:nnlg/utils/edusys/entity/TeachingEvaForm.dart';

class TeachingEva{
  String? _teachingEvaluationHTML;
  TeachingEva(this._teachingEvaluationHTML);

  getTeachingEvaList(){
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
      TeachingEvaForm(xh,xn,pjfl,pjpc,kssj,jssj,pjurl)
      evalForms.add();
      // for(Match m2 in match2){
      //   return m2.group(1).toString();
      // }
      break;
    }
  }
}
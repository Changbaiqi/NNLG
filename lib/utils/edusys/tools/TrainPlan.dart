/* FileName TrainPlan
 *
 * @Author 20840
 * @Date 2024/2/2 1:27
 *
 * @Description TODO
 */
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';

class TrainPlan{
  String? _trainPlanHTML;
  TrainPlan(this._trainPlanHTML);

  /**
   * [title] getTrainPlanList
   * [author] 长白崎
   * [description] 将培养计划的HTML转成JSON
   * [date] 1:41 2024/2/2
   * [param] null
   * [return]
   */
  List<TrainPlanInForm> getTrainPlanList(){
    RegExp regExp1 = RegExp(r'<tr>[^<]+<td>([\d]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td align="left">([^<]+)</td>[^<]+<td align="left">([^<]+)</td>[^<]+<td align="left">([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+<td>([^<]+)</td>[^<]+</tr>');

    Iterable<Match> match1 = regExp1.allMatches(_trainPlanHTML!);
    List<TrainPlanInForm> trainPlanInForms = [];
    for(Match m in match1){
      var number = m.group(1);//序号
      var semester = m.group(2); //学期
      var code = m.group(3);//课程编号
      var courseName = m.group(4);//课程名称
      var unit = m.group(5);//开课单位
      var credit = m.group(6);//学分
      var creditHour= m.group(7);//学时
      var evaMode= m.group(8);//考核方式
      var property= m.group(9); //课程属性
      var isExam= m.group(10);//是否考试
      trainPlanInForms.add(TrainPlanInForm(number: number,semester: semester,code: code,courseName: courseName,unit: unit,credit: credit,creditHour: creditHour,evaMode: evaMode,property: property,isExam: isExam));
    }
    return trainPlanInForms;
  }
}
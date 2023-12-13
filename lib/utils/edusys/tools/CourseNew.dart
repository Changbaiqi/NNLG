import '../entity/CourseForm.dart';

class CourseNew{
  String? _courseHTML;
  List<List<List<CourseForm?>>>? _courFormList;

  CourseNew(String courseHTML){
    this._courseHTML = courseHTML;
    _courFormList = [];


    String tableString = "";
    //截取课表部分
    RegExp exp = RegExp(r'<table[^>]*?>([\s\S]*?)(</table>)');
    Iterable<Match> tecc = exp.allMatches(courseHTML);
    for(Match m in tecc){
      // String match = m.group(1).toString();
      tableString = m.group(1).toString();
    }

    RegExp trExp = RegExp(r'<tr>([\s\S]*?)(</tr>)');
    Iterable<Match> trMatcher = trExp.allMatches(tableString);
    List<String> trList = [];
    for(Match m in trMatcher){
      String group = m.group(1).toString();
      trList.add(group);
    }
    
    RegExp tdExp = RegExp(r'class="kbcontent"[^>]*>([\s\S]*?)(</div>)');
    List<List<String>> tdCourseList = [];
    for(int i =0 ; i < trList.length-1 ; ++i){
      Iterable<Match> tdMatcher = tdExp.allMatches(trList[i]);
      List<String> tdCourse = [];
      for(Match m in tdMatcher){
        String group = m.group(1).toString();
        tdCourse.add(group);
      }
      tdCourseList.add(tdCourse);
    }

    for(int i = 0; i < tdCourseList.length ; ++i) {
      List<List<CourseForm?>> formList = [];
      for (int y = 0; y < tdCourseList[i].length; ++y) {
        String tdListStr = tdCourseList[i][y];
        List<String> split = tdListStr.split("------------");
        List<CourseForm?> courses = [];
        for (String s in split) {
          courses.add(toCourseForm(s));
        }
        formList.add(courses);
      }
      _courFormList?.add(formList);
    }

  }
  CourseForm? toCourseForm(String courseStr){
    //如果为空课表
    if(courseStr.length<13 && courseStr.contains("&nbsp"))
      return null;
    CourseForm courseForm = CourseForm();
    
    //截取课程名称
    //首先去除杂符号
    RegExp regExp = RegExp(r'-{3,20}<[^b]*br[^>]*>([\s\S]*)');
    Iterable<Match> match=regExp.allMatches(courseStr);
    for(Match m in match){
      String group = m.group(1).toString();
      courseStr = group;
    }
    
    RegExp reg = RegExp(r"([\s\S]*?)<br/>[^>]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<[\s\S]*?'>\(([0-9]*?)\)[\s\S]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<");
    Iterable<Match> mat = reg.allMatches(courseStr);
    for(Match match in mat){
      courseForm.courseName = match.group(1);
      courseForm.courseTeacher = match.group(2);
      courseForm.courseWeek = match.group(5);
      courseForm.courseClassRoom = match.group(6);
    }
    return courseForm;
  }


  String getAllJSON(){
    String stringBuffer = "";
    stringBuffer+="[";
    for(int i=0; i < _courFormList!.length;++i){
      stringBuffer+="[";
      for(int y =0 ; y < _courFormList![i].length ; ++y){
        stringBuffer+="[";
        for(int x = 0 ;x < _courFormList![i][y].length; ++x){
          CourseForm? courseForm = _courFormList![i][y][x];
          if(courseForm==null)
            continue;
          stringBuffer+=courseForm.toJson()!;
          if(x+1!=_courFormList![i][y].length)
            stringBuffer+=",";
        }
        stringBuffer+="]";
        if(y+1!=_courFormList![i].length)
          stringBuffer+=",";
      }
      stringBuffer+="]";
      if(i+1!=_courFormList!.length)
        stringBuffer+=",";
    }
    stringBuffer+="]";
    return stringBuffer;

  }

}
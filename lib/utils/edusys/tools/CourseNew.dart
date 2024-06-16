import 'package:nnlg/utils/edusys/entity/CourseForm.dart';


class CourseNew{
  String? courseHTML;
  List<List<List<CourseForm?>>> courFormList=[];

  CourseNew(String courseHTML) {
    this.courseHTML = courseHTML;
    //截取课表部分
    RegExp regExp = RegExp(r'<table[^>]*?>([\s\S]*?)(</table>)');
    Iterable<Match> match = regExp.allMatches(courseHTML);
    // Pattern pattern = Pattern.compile("<table[^>]*?>([\\s\\S]*?)(</table>)");
    // Matcher matcher = pattern.matcher(courseHTML);
    String? tableString = null;
    // while (matcher.find()) {
    for(Match m in match){
      String group = m.group(1).toString();
      tableString = m.group(1).toString();
    }

    //截取tr，一般一共有8份，第一份为星期几的表格，最后一份为备注项，中间的部分全部为第几大节的项
    RegExp reRegExp = RegExp(r'<tr>([\s\S]*?)(</tr>)');
    Iterable<Match> reMatch = reRegExp.allMatches(tableString!);
    // Pattern trPattern = Pattern.compile("<tr>([\\s\\S]*?)(</tr>)");
    // Matcher trMatcher = trPattern.matcher(tableString);
    List<String> trList = [];
    for(Match m in reMatch){
      String group = m.group(1).toString();
      trList.add(group);
    }

    //主截取课程第几大节那一横着的所有部分部分
    RegExp tdRegExp = RegExp(r'class="kbcontent"[^>]*>([\s\S]*?)(</div>)');
    // Pattern tdPattern = Pattern.compile("class=\"kbcontent\"[^>]*>([\\s\\S]*?)(</div>)");

    List<List<String>> tdCourseList = [];
    for (int i = 1; i < trList.length - 1; i++) {
      // Matcher tdMatcher = tdPattern.matcher(trList.get(i));
      Iterable<Match> tdMatch = tdRegExp.allMatches(trList[i]);
      List<String> tdCourse = [];
      // while (tdMatcher.find()) {
      for(Match m in tdMatch){
        String group = m.group(1).toString();
        tdCourse.add(group);
      }
      tdCourseList.add(tdCourse);
    }
//        System.out.println();

    for (int i = 0; i < tdCourseList.length; i++) {
      List<List<CourseForm?>> formList = [];
      for (int y = 0; y < tdCourseList[i].length; y++) {
        String tdListStr = tdCourseList[i][y];
        List<String> split = tdListStr.split("------------");
        List<CourseForm?> courses = [];
        for (String s in split) {
          courses.add(_toCourseForm(s));
//                    System.out.println(s);
        }
        formList.add(courses);
      }
      courFormList.add(formList);
    }

  }


  CourseForm? _toCourseForm(String courseStr) {
    //如果为空课表
    if (courseStr.length < 13 && courseStr.contains("&nbsp"))
      return null;
    CourseForm courseForm = CourseForm();

    //截取课程名称
    //首先去除杂符号
    // Pattern pattern = Pattern.compile("-{3,20}<[^b]*br[^>]*>([\\s\\S]*)");
    // Matcher matcher = pattern.matcher(courseStr);
    RegExp regExp = RegExp(r'-{3,20}<[^b]*br[^>]*>([\s\S]*)');
    RegExpMatch? match = regExp.firstMatch(courseStr);
    if (match!=null) {
      courseStr = match.group(1).toString();
    }

    // Pattern pat = Pattern.compile("([\\s\\S]*?)<br/>[^>]*?>([\\s\\S]*?)<[\\s\\S]*?'>([\\s\\S]*?)<[\\s\\S]*?'>\\(([0-9]*?)\\)[\\s\\S]*?>([\\s\\S]*?)<[\\s\\S]*?'>([\\s\\S]*?)<");
    // Matcher mat = pat.matcher(courseStr);
    RegExp reg = RegExp(r"([\s\S]*?)<br/>[^>]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<[\s\S]*?'>\(([0-9]*?)\)[\s\S]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<");
    RegExpMatch? mat = reg.firstMatch(courseStr);
    if(mat!=null){
//            courseForm.setCourseName(mat.group(1));
//            System.out.println("课程名:"+mat.group(1));
//            System.out.println("老师:"+mat.group(2));
//            System.out.println("班级:"+mat.group(3));
//            System.out.println("人数:"+mat.group(4));
//            System.out.println("课程所在周节:"+mat.group(5));
//            System.out.println("上课地点:"+mat.group(6));
      courseForm.courseName=mat.group(1).toString();
      courseForm.courseTeacher=mat.group(2).toString();
      courseForm.courseWeek=mat.group(5).toString();
      courseForm.courseClassRoom=mat.group(6).toString();
    }else{
      // Pattern patCourseName = Pattern.compile("([\\s\\S]*?)<br/>");
      // Matcher matCourseName = patCourseName.matcher(courseStr);
      RegExp regCourseName = RegExp(r"([\s\S]*?)<br/>");
      RegExpMatch? matCourseName = regCourseName.firstMatch(courseStr);
      if(matCourseName!=null){
        courseForm.courseName=matCourseName.group(1).toString();
      }else{
        courseForm.courseName="无";
      }

      // Pattern patCourseTeacher = Pattern.compile("[\\s\\S]*?'老师'[^>]*?>([\\s\\S]*?)<[\\s\\S]*?");
      // Matcher matCourseTeacher = patCourseTeacher.matcher(courseStr);
      RegExp regCourseTeacher = RegExp(r"[\s\S]*?'老师'[^>]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseTeacher = regCourseTeacher.firstMatch(courseStr);
      if(matCourseTeacher!=null){
        courseForm.courseTeacher=matCourseTeacher.group(1).toString();
      }else{
        courseForm.courseTeacher="无";
      }
      // Pattern patCourseWeek = Pattern.compile("[\\s\\S]*?>\\(([0-9]*?)\\)[\\s\\S]*?>([\\s\\S]*?)<[\\s\\S]*?");
      // Matcher matCourseWeek = patCourseWeek.matcher(courseStr);
      RegExp regCourseWeek = RegExp(r"[\s\S]*?>\(([0-9]*?)\)[\s\S]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseWeek = regCourseWeek.firstMatch(courseStr);
      if(matCourseWeek!=null){
        courseForm.courseWeek=matCourseWeek.group(2).toString();
      }else{
        courseForm.courseWeek="无";
      }

      // Pattern patCourseClassRoom = Pattern.compile("[\\s\\S]*?'上课地点'[^>]*?>([\\s\\S]*?)<[\\s\\S]*?");
      // Matcher matCourseClassRoom = patCourseClassRoom.matcher(courseStr);
      RegExp regCourseClassRoom = RegExp(r"[\s\S]*?'上课地点'[^>]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseClassRoom = regCourseClassRoom.firstMatch(courseStr);
      if(matCourseClassRoom!=null){
        courseForm.courseClassRoom=matCourseClassRoom.group(1).toString();
      }else{
        courseForm.courseClassRoom="无";
      }
    }
//        System.out.println(courseStr);
    return courseForm;
  }

  String getAllJSON(){
    String stringBuffer = "";
    stringBuffer+='[';
    for (int i = 0; i < courFormList.length; i++) {
      stringBuffer+='[';
      for (int y = 0; y < courFormList[i].length; y++) {
        stringBuffer+='[';
        for (int x = 0; x < courFormList[i][y].length; x++) {
          //添加到缓存字符串中
          CourseForm? courseForm = courFormList[i][y][x];
          if(courseForm==null)
            continue;
          stringBuffer+=courseForm.toJson()!;
          if(x+1!=courFormList[i][y].length)
            stringBuffer+=',';
        }
        stringBuffer+=']';
        if(y+1!=courFormList[i].length)
          stringBuffer+=',';
      }
      stringBuffer+="]";
      if(i+1!=courFormList.length)
        stringBuffer+=',';
    }
    stringBuffer+="]";
    return stringBuffer.toString();
  }

}
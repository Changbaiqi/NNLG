/* FileName CourseForAll
 *
 * @Author 20840
 * @Date 2024/7/13 23:48
 *
 * @Description TODO
 */

import 'dart:convert';

import '../entity/CourseForm.dart';

class CourseForAll {
  String? courseHTML;
  List<List<List<CourseForm?>>> courFormList = [];
  String? remark;

  CourseForAll(String courseHTML) {
    this.courseHTML = courseHTML;
    //截取课表部分
    RegExp regExp = RegExp(r'<table[^>]*?>([\s\S]*?)(</table>)');
    Iterable<Match> match = regExp.allMatches(courseHTML);
    // Pattern pattern = Pattern.compile("<table[^>]*?>([\\s\\S]*?)(</table>)");
    // Matcher matcher = pattern.matcher(courseHTML);
    String? tableString = null;
    // while (matcher.find()) {
    for (Match m in match) {
      String group = m.group(1).toString();
      tableString = m.group(1).toString();
    }

    //截取tr，一般一共有8份，第一份为星期几的表格，最后一份为备注项，中间的部分全部为第几大节的项
    RegExp reRegExp = RegExp(r'<tr>([\s\S]*?)(</tr>)');
    Iterable<Match> reMatch = reRegExp.allMatches(tableString!);
    // Pattern trPattern = Pattern.compile("<tr>([\\s\\S]*?)(</tr>)");
    // Matcher trMatcher = trPattern.matcher(tableString);
    List<String> trList = [];
    for (Match m in reMatch) {
      String group = m.group(1).toString();
      trList.add(group);
    }

    //主截取课程第几大节那一横着的所有部分部分
    RegExp tdPattern = RegExp(r'class="kbcontent"[^>]*>([\s\S]*?)(</div>)');

    List<List<String>> tdCourseList = [];
    for (int i = 1; i < trList.length - 1; i++) {
      Iterable<Match> tdMatcher = tdPattern.allMatches(trList[i]);
      List<String> tdCourse = [];
      for (Match m in tdMatcher) {
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

    //备注信息截取

    RegExp remarkPt = RegExp(
        r'<th width=\"[^\"]*\" height=\"[^\"]*\" align=\"[^\"]*\">[^<]*</th> <td colspan=\"[^\"]*\" align=\"[^\"]*\">([^<]*)</td>');
    Match? remarkMatcher = remarkPt.firstMatch(courseHTML);
    if (remarkMatcher != null) {
      remark = remarkMatcher.group(1);
    }
  }

  CourseForm? _toCourseForm(String courseStr) {
    //如果为空课表
    if (courseStr.length < 13 && courseStr.contains("&nbsp")) return null;
    CourseForm courseForm = new CourseForm();

    //截取课程名称
    //首先去除杂符号
    RegExp pattern = RegExp(r"-{3,20}<[^b]*br[^>]*>([\s\S]*)");
    Match? matcher = pattern.firstMatch(courseStr);
    if (matcher != null) {
      courseStr = matcher.group(1).toString();
    }

    RegExp pat = RegExp(
        r"([\s\S]*?)<br/>[^>]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<[\s\S]*?'>\(([0-9]*?)\)[\s\S]*?>([\s\S]*?)<[\s\S]*?'>([\s\S]*?)<");
    Match? mat = pat.firstMatch(courseStr);

    if (mat != null) {
//            courseForm.setCourseName(mat.group(1));
//            System.out.println("课程名:"+mat.group(1));
//            System.out.println("老师:"+mat.group(2));
//            System.out.println("班级:"+mat.group(3));
//            System.out.println("人数:"+mat.group(4));
//            System.out.println("课程所在周节:"+mat.group(5));
//            System.out.println("上课地点:"+mat.group(6));
      courseForm.courseName = mat.group(1).toString();
      courseForm.courseTeacher = mat.group(2).toString();
      courseForm.courseWeek = mat.group(5).toString();
      courseForm.courseClassRoom = mat.group(6).toString();
    } else {
      //如果全局匹配不管用，那么采用局部匹配策略
      RegExp regCourseName = RegExp(r"([\s\S]*?)<br/>");
      RegExpMatch? matCourseName = regCourseName.firstMatch(courseStr);
      if (matCourseName != null) {
        courseForm.courseName = matCourseName.group(1).toString();
      } else {
        courseForm.courseName = "无";
      }

      RegExp regCourseTeacher =
          RegExp(r"[\s\S]*?'老师'[^>]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseTeacher = regCourseTeacher.firstMatch(courseStr);
      if (matCourseTeacher != null) {
        courseForm.courseTeacher = matCourseTeacher.group(1).toString();
      } else {
        courseForm.courseTeacher = "无";
      }
      RegExp regCourseWeek =
          RegExp(r"[\s\S]*?>\(([0-9]*?)\)[\s\S]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseWeek = regCourseWeek.firstMatch(courseStr);
      if (matCourseWeek != null) {
        courseForm.courseWeek = matCourseWeek.group(2).toString();
      } else {
        courseForm.courseWeek = "无";
      }

      RegExp regCourseClassRoom =
          RegExp(r"[\s\S]*?'上课地点'[^>]*?>([\s\S]*?)<[\s\S]*?");
      RegExpMatch? matCourseClassRoom =
          regCourseClassRoom.firstMatch(courseStr);
      if (matCourseClassRoom != null) {
        courseForm.courseClassRoom = matCourseClassRoom.group(1).toString();
      } else {
        courseForm.courseClassRoom = "无";
      }
    }

    //匹配周和节所在周列表
    String? courseWeek = courseForm.courseWeek;
    RegExp weekListPattern = RegExp(r"([^(]*)\(([^)]*)\)\[([^节]*)节\]");
    Match? weekListMatcher = weekListPattern.firstMatch(courseWeek!);
    if (weekListMatcher != null) {
      //匹配周list
      List<int> weekList = [];
      String weeks = weekListMatcher.group(1).toString(); //周字符串
      String model = weekListMatcher.group(2).toString(); //匹配模式，是全部还是单周还是双周
      List<String> weeksSplit = weeks.split(",");
      for (int i = 0; i < weeksSplit.length; i++) {
        //有-
        if (weeksSplit[i].contains("-")) {
          int start = int.parse(weeksSplit[i].split("-")[0]);
          int end = int.parse(weeksSplit[i].split("-")[1]);
          for (int j = start; j <= end; ++j) {
            if (model == "全部") {
              weekList.add(j);
            } else if (model == "单周" && j % 2 != 0) {
              weekList.add(j);
            } else if (model == "双周" && j % 2 == 0) {
              weekList.add(j);
            }
          }
        } else {
          //无-
          int week = int.parse(weeksSplit[i]);
          if (model == "全部") {
            weekList.add(week);
          } else if (model == "单周" && week % 2 != 0) {
            weekList.add(week);
          } else if (model == "双周" && week % 2 == 0) {
            weekList.add(week);
          }
        }
        courseForm.courseWeekList = weekList;
      }

      //匹配节list
      List<int> selectionList = [];
      String sections = weekListMatcher.group(3).toString();
      List<String> selectionsSplit = sections.split(",");
      for (int i = 0; i < selectionsSplit.length; i++) {
        //有-
        if (selectionsSplit[i].contains("-")) {
          List<String> list = selectionsSplit[i].split("-");
          for (int i1 = 0; i1 < list.length; i1++) {
            selectionList.add(int.parse(list[i1]));
          }
        } else {
          //无-
          int section = int.parse(selectionsSplit[i]);
          selectionList.add(section);
        }
        courseForm.courseSectionList = selectionList;
      }
    }
//        System.out.println(courseStr);
    return courseForm;
  }

  /**
   * 直接获取列表数据
   * @return
   */
  List<List<List<CourseForm?>>> getCourFormList() {
    return courFormList;
  }

  String getAllSemesterJson(int minWeek) {
    // ObjectMapper objectMapper = new ObjectMapper();
    // HashMap<String,Object> result = new HashMap<>();
    Map<String, dynamic> result = {};
    List<List<List<List<Map<String, dynamic>?>>>> list = [];
    for (int i = 0; i < minWeek; i++) { //第几周
      list.add([]);
      for (int j = 0; j < 12; ++j) {//第几行
        list[i].add([]);
        for (int z = 0; z < 7; ++z) {//第几列，也就是星期几
          list[i][j].add([]);
        }
      }
    }

    Set<String> repeat = Set(); //去重，防止重复添加
    for (int i = 0; i < courFormList.length; i++) {
      //第几行
      for (int j = 0; j < courFormList[i].length; ++j) {
        //第几列
        for (int z = 0; z < courFormList[i][j].length; ++z) {
          CourseForm? courseForm = courFormList[i][j][z];
          if (courseForm == null ||
              repeat.contains(jsonEncode(courseForm.toJsonMap()) + "$j")) continue;
          for (int week in courseForm.courseWeekList!) {
            for (int selection in courseForm.courseSectionList!) {
              if(list[week-1].length<selection) continue; //跳过离谱的节数课程
              list[week - 1][selection - 1][j].add(courseForm.toJsonMap());
            }
          }
          repeat.add(jsonEncode(courseForm.toJsonMap()) + "$j");
        }
      }
    }

    result["remark"] = remark;
    result["courses"] = list;
    return jsonEncode(result);
  }

  static String listTurnAllSemesterJson(List<List<List<CourseForm?>>> courFormList, int minWeek) {
    // ObjectMapper objectMapper = new ObjectMapper();
    // HashMap<String,Object> result = new HashMap<>();
    Map<String, dynamic> result = {};
    List<List<List<List<Map<String, dynamic>?>>>> list = [];
    for (int i = 0; i < minWeek; i++) {
      list.add([]);
      for (int j = 0; j < 12; ++j) {
        list[i].add([]);
        for (int z = 0; z < 7; ++z) {
          list[i][j].add([]);
        }
      }
    }

    Set<String> repeat = Set(); //去重，防止重复添加
    for (int i = 0; i < courFormList.length; i++) {
      //第几行
      for (int j = 0; j < courFormList[i].length; ++j) {
        //第几列
        for (int z = 0; z < courFormList[i][j].length; ++z) {
          CourseForm? courseForm = courFormList[i][j][z];
          if (courseForm == null ||
              repeat.contains(jsonEncode(courseForm.toJsonMap()) + "$j"))
            continue;
          for (int week in courseForm.courseWeekList!) {
            for (int selection in courseForm.courseSectionList!) {
              list[week - 1][selection - 1][j].add(courseForm.toJsonMap());
            }
          }
          repeat.add(jsonEncode(courseForm.toJsonMap()) + "$j");
        }
      }
    }

    result["remark"] = "";
    result["courses"] = list;
    return jsonEncode(result);
  }
}

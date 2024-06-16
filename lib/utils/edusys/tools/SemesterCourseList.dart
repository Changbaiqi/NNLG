/* FileName SemesterCourseList
 *
 * @Author 20840
 * @Date 2024/6/16 14:17
 *
 * @Description TODO
 */




class SemesterCourseList {

  String? _semesterCourseListHTML;

  List<String> courseList = [];

  String allJSON = "";



  SemesterCourseList(String semesterCourseListHTML){

    this._semesterCourseListHTML = semesterCourseListHTML;

    getCourseList();
  }


  void getCourseList(){
    RegExp regExp = RegExp(r'学年学期：([\w\W]+)</select>');
    RegExpMatch? match = regExp.firstMatch(_semesterCourseListHTML!);

    if(match!=null){
      RegExp regExp1 = RegExp(r'>([\s]*)([^<]{9,15})([\s]*)</option>');
      Iterable<Match> match1 = regExp1.allMatches(match.group(1).toString());
      for(Match m in match1){
        courseList.add(m.group(2).toString());
      }

    }


  }



  String getAllList(){

    allJSON+="[";
    for(int i = 0 ; i < courseList.length ; ++i ){




      allJSON+="\""+ courseList[i] +"\"";

      if(i!=courseList.length-1)
        allJSON+=",";

    }
    allJSON+="]";

    return allJSON.toString();
  }



}

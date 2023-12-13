import 'package:flutter_svg/flutter_svg.dart';

class CourseForm{
  String? courseName;
  String? courseClassRoom;
  String? courseTeacher;
  String? courseWeek;

  String? toJson() {
    String? stringBuffer= "";
    stringBuffer+="{";
    if(courseName!=null)
      stringBuffer+="\"courseName\":"+"\""+courseName!+"\"";
    if(courseClassRoom!=null)
      stringBuffer+=",\"courseClassRoom\":"+"\""+courseClassRoom!+"\"";
    if(courseTeacher!=null)
      stringBuffer+=",\"courseTeacher\":"+"\""+courseTeacher!+"\"";
    if(courseWeek!=null)
      stringBuffer+=",\"courseWeek\":"+"\""+courseWeek!+"\"";
    stringBuffer+="}";
    return stringBuffer;
  }
}
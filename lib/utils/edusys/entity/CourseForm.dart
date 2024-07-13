import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';

class CourseForm{
  String? courseName;
  String? courseClassRoom;
  String? courseTeacher;
  String? courseWeek;
  List<int>? courseWeekList;
  List<int>? courseSectionList;

  String? toJson() {
    String stringBuffer= "";
    stringBuffer+="{";
    // if(courseName!=null)
    //   stringBuffer+="\"courseName\":"+"\""+courseName!+"\"";
    // if(courseClassRoom!=null)
    //   stringBuffer+=",\"courseClassRoom\":"+"\""+courseClassRoom!+"\"";
    // if(courseTeacher!=null)
    //   stringBuffer+=",\"courseTeacher\":"+"\""+courseTeacher!+"\"";
    // if(courseWeek!=null)
    //   stringBuffer+=",\"courseWeek\":"+"\""+courseWeek!+"\"";
    // stringBuffer+="}";

    if(courseName!=null)
      stringBuffer+="\"courseName\":"+"\""+courseName!+"\"";
    if(courseClassRoom!=null)
      stringBuffer+=",\"courseClassRoom\":"+"\""+courseClassRoom!+"\"";
    if(courseTeacher!=null)
      stringBuffer+=",\"courseTeacher\":"+"\""+courseTeacher!+"\"";
    if(courseWeek!=null)
      stringBuffer+=",\"courseWeek\":"+"\""+courseWeek!+"\"";

    if(courseWeekList!=null){
      stringBuffer+=",\"courseWeekList\":";
      stringBuffer+="[";
      for (int i = 0; i < courseWeekList!.length; i++) {
        stringBuffer+='${courseWeekList![i]}';
        if(i!=courseWeekList!.length-1)stringBuffer+=',';
      }
      stringBuffer+=']';
    }

    if(courseSectionList!=null){
      stringBuffer+=",\"courseSectionList\":";
      stringBuffer+="[";
      for (int i = 0; i < courseSectionList!.length; i++) {
        stringBuffer+='${courseSectionList![i]}';
        if(i!=courseSectionList!.length-1)stringBuffer+=',';
      }
      stringBuffer+="]";
    }

    stringBuffer+="}";
    // log(stringBuffer);
    return stringBuffer;
  }
}
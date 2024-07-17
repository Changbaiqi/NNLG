import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nnlg/utils/CourseUtil.dart';

import '../../utils/FileUtils.dart';
import 'state.dart';

class SoftwareDevelopmentTestViewLogic extends GetxController {
  final SoftwareDevelopmentTestViewState state = SoftwareDevelopmentTestViewState();
  final tableJson = RxMap();
  final courseTable = RxMap();
  final isMin = false.obs;
  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 课表数据与控件之间的适配器
   * [date] 11:49 2024/7/17
   * [param] null
   * [return]
   */
  tableAdapter(List<dynamic> courses){
    Map<String,dynamic> result={"tables":[]};
    // log(jsonEncode(courses));
    // log('${courses.length}');

    for(int x = 0 ; x<courses[0].length;++x){ //横向
      String repeat = "[]";
      int rowStart =0;
      int rowEnd =0;
      int columStart = 0;
      int columEnd =0;
      for(int y =0;y<courses.length;++y){ //竖向
        String inform = jsonEncode(courses[y][x]);
        if(repeat!=inform){
          if(repeat!="[]" && columStart!=0){
            // log(repeat);
            result['tables'].add({
              "rowStart": rowStart+1,
              "rowEnd": rowEnd+1,
              "columStart": columStart,
              "columEnd": columEnd,
              "title": "${jsonDecode(repeat).length>1?"有多门课程同时进行，点击查看详细":jsonDecode(repeat)[0]['courseName']}",
              "style": {
                "textColor": jsonDecode(repeat).length>1?[255,255,0,0]:[255,0,0,0]
              },
              "data": jsonDecode(repeat)
            });
          }
          rowStart = y;
          rowEnd = y;
          columStart = x+1;
          columEnd = x+1;
          repeat = inform;
          continue;
        }
        rowEnd= rowEnd<y?y:rowEnd;
      }

    }
    return result;
  }
  //8周，2022-2023-1
  @override
  void onInit() {
    FileUtils.loadJsonFromAssets("assets/files/testCourse.json").then((value){
        tableJson.value =tableAdapter(jsonDecode(value));
    });
    // CourseUtil().getAllCourseSemesterList("2022-2023-1").then((value) {
    //   courseTable.value = jsonDecode(value);
    //   courseTable.refresh();
    //   tableJson.value =tableAdapter(courseTable.value["courses"][7]);
    // });
    // FileUtils.loadJsonFromAssets("assets/files/scheduleJson.json").then((value){ tableJson.value=value;tableJson.refresh();});
  }
}

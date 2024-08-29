import 'dart:collection';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/web/ShareCourseWeb.dart';

class CourseSharedShowViewState {
  final accountData = (LinkedHashMap<String,dynamic>()).obs;

  final selectSemester = "".obs; //当前选择的学年
  final semesterList = [].obs; //学期列表
  final oldWeekCourseList = [] .obs;//课表json

  final title = "".obs;
  final  viewPageVar=(null as Widget?).obs;
  //用于寄存当前所在的周数，便于重新加载页面的时候跳转到此
  final nowIndex = (CourseData.nowWeek.value - 1).obs;

  //课表显示的列表
  final courseWeek = <Widget>[].obs;

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 获取课表对应json数据
   * [date] 23:09 2024/8/7
   * [param] null
   * [return]
   */
  getShareCourseData(String semester) async {
    await ShareCourseWeb().getShareCourseData(accountData.value['userAccount'],semester).then((value){
      // print(value.data.courseList);
      if(value['code']!=200){
        Get.snackbar(
          "课表通知",
          "${value['message']}",
          duration: Duration(milliseconds: 1500),
        );
        return;
      }

      if(value['data']['semesterList']!=null) //学年选择赋值
        semesterList.value = value['data']['semesterList'];

      selectSemester.value = value['data']['selectSemester'];
      oldWeekCourseList.value = value['data']['courseList'];
      log('${value['data']['courseList'] as List}');
      oldWeekCourseList.refresh();
    });
  }
  CourseSharedShowViewState() {
    ///Initialize variables
  }
}

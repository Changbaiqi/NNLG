import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';

class MainCourseViewState {
  final title = "".obs;
  final  viewPageVar=(null as Widget?).obs;
  //用于寄存当前所在的周数，便于重新加载页面的时候跳转到此
  final nowIndex = (CourseData.nowWeek.value - 1).obs;

  //课表显示的列表
  final courseWeek = <Widget>[].obs;
  MainCourseViewState() {
    ///Initialize variables
  }
}

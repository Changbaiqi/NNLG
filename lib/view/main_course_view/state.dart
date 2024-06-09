import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/HexColor.dart';

class MainCourseViewState {
  final  viewPageVar=(null as Widget?).obs;
  //用于寄存当前所在的周数，便于重新加载页面的时候跳转到此
  final nowIndex = (CourseData.nowWeek.value).obs;

  //课表显示的列表
  final courseWeek = <Widget>[].obs;

  final courseRefreshStatus =  0.obs;  //课表刷新状态，0为未开始刷新，1代表刷新中，3代表刷新结束
  MainCourseViewState() {
    ///Initialize variables
  }

   stringTurn16Color(String str){
    // String uuid =
    int res =0;
    for(int i =0;i<str.length;++i){
      res = res + (int.parse(str.codeUnitAt(i).toRadixString(16),radix: 16)*41);
    }
    // print('${res.toRadixString(16)}');
    return HexColor("${res.toRadixString(16)}");
    // print(res);
    // return HexColor("${res}");
  }
}

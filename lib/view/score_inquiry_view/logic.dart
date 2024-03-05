import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/CourseScoreUtil.dart';

import 'state.dart';

class ScoreInquiryViewLogic extends GetxController {
  final ScoreInquiryViewState state = ScoreInquiryViewState();





  // future() async {
  //   await showScoreList(state.selectTime.value);
  //   return "";
  // }

  //初始化日期列表
  initSearchList() async {
    await CourseScoreUtil().getReportCardQueryList().then((value) {
      state.searList.value = value;
    });
  }

  //通过日期选择相关成绩展示
  showScoreList(String time) async {
    if (time == '全部学期') time = '';
    state.showState.value=0;
    await CourseScoreUtil().getScoreList(time).then((value) {
      state.scoreList.value = value;
      state.showState.value=1;
      //print(value);
    });
  }

  //成绩颜色判断
  Color scoreColors(String score) {
    double? num = double.tryParse(score);
    if (num == null) {
      if (score == '不合格') return Colors.red;
      if (score == '合格') return Colors.amber;
      if (score == '优') return Colors.deepPurple;
      return Colors.white;
    }
    if (num! < 60) return Colors.red;
    if (num == 60) return Colors.amber;
    if (num > 90) return Colors.deepPurple;

    return Colors.white;
  }

  @override
  void onInit() {
    initSearchList();
    showScoreList(state.selectTime.value);
  }
}

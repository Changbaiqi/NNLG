import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/utils/CourseScoreUtil.dart';
import 'package:callo/utils/GlassUI.dart';

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

  //成绩颜色判断（M3：不及格=error，合格=tertiary，优秀=primary，其余=onSurface）
  Color scoreColors(String score) {
    double? num = double.tryParse(score);
    if (num == null) {
      if (score == '不合格') return GlassTheme.scheme.error;
      if (score == '不及格') return GlassTheme.scheme.error;
      if (score == '合格') return GlassTheme.scheme.tertiary;
      if (score == '及格') return GlassTheme.scheme.tertiary;
      if (score == '优') return GlassTheme.scheme.primary;
      return GlassTheme.scheme.onSurface;
    }
    if (num! < 60) return GlassTheme.scheme.error;
    if (num == 60) return GlassTheme.scheme.tertiary;
    if (num >= 90) return GlassTheme.scheme.primary;

    return GlassTheme.scheme.onSurface;
  }

  @override
  void onInit() {
    initSearchList();
    showScoreList(state.selectTime.value);
  }
}

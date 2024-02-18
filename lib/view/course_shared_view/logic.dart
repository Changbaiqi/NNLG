import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class CourseSharedViewLogic extends GetxController  with GetSingleTickerProviderStateMixin{
  final CourseSharedViewState state = CourseSharedViewState();



  @override
  void onInit() {
    super.onInit();
    //搜索框监听
    state.searchController.value.addListener(() {
      String txt = state.searchController.value.text;
      //如果文本为空
      if (txt.isEmpty)
        state.searchTxtIsEmpty.value = true;
      else
        state.searchTxtIsEmpty.value = false;
    });

    //初始化账号列表
    state.getShareAccountList();
    // state.tabController.value = TabController(length: 2,vsync: this);
  }
}
